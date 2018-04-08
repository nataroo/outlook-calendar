//
//  OutlookCalendarTests.swift
//  OutlookCalendarTests
//
//  Created by Roopa Natarajan on 3/31/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import XCTest
@testable import OutlookCalendar

class OutlookCalendarTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        CoreDataStack.sharedInstance.saveContext()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJsonParser() {
        // Verify that the json parser, parses the static input and returns an array of 101 values
        let array = JsonParser.JSONParseArray()
        XCTAssertNotNil(array)
        XCTAssert(array?.count == 101)
    }

    func testCoreDataSave() {
        let testJson = singleJsonResponseForTest()
        // Save the json response to core data model
        _ = ObjectStore.sharedInstance.createOrUpdateEventEntityFrom(elementInfo: testJson)
        do {
            // Save the data
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
        // Check if th event is saved in core data model
        let event: Event = ObjectStore.sharedInstance.fetchEventWithId(id: eventIdForTest())!
        XCTAssertNotNil(event)
        // Check if the attributes have been set right
        XCTAssert(event.eventTitle == "meeting58")
        XCTAssert(event.eventDescription == "My own description, Id:5")
        XCTAssert(event.eventDuration == "88")
        XCTAssert(event.eventDateTimeUTC == "2018-02-26T01:06:14")
        XCTAssert(event.eventDateLocal == "2018-02-26")
        XCTAssert(event.eventTimeLocal == "01:06:14")
        XCTAssert(event.location?.locationId == "4036fb00-d290-4c4e-a806-78bb4b642077")
        XCTAssert(event.location?.buildingNumber == "58")
        XCTAssert(event.location?.roomNumber == "10")
        XCTAssert(event.attendees?.count == 4)
    }
    
    func testCoreDataDelete() {
        // TODO - Needs a delete functionality in Object Store
        // Only if delete is implemented, we can check if the above creation works every time
        // Currently we are just updating the same object in the core data model during every test
    }
    
    func testDateTimeUtil() {
        let date = DateTimeUtil.dateFromValues(year: 2018, month: 4, day: 7, hour: 0, minute: 0, second: 0)
        XCTAssertNotNil(date)
        XCTAssert(DateTimeUtil.yearFromDate(date: date) == 2018)
        XCTAssert(DateTimeUtil.monthFromDate(date: date) == 4)
        XCTAssert(DateTimeUtil.dayFromDate(date: date) == 7)
        XCTAssert(DateTimeUtil.weekdayFromDate(date: date) == 7)
    }

    func singleJsonResponseForTest() -> AnyObject {
        return "{\"eventId\":\"2252bcaf-21f4-4c23-901c-b928f5ad189b\",\"eventTitle\":\"meeting58\",\"eventDescription\":\"My own description, Id:5\",\"eventDateTimeUTC\":\"2018-02-26T01:06:14\",\"eventDuration\":\"88\",\"location\":{\"locationId\":\"4036fb00-d290-4c4e-a806-78bb4b642077\",\"buildingNumber\":\"58\",\"roomNumber\":\"10\"},\"attendees\":[{\"attendeeId\":\"dfa956eb-316c-481e-b8f6-fae3118d4941\",\"person\":{\"personId\":\"0aec199d-36cb-475e-b7bb-4add89e22a8b\",\"firstName\":\"f29-myFirstName-19f\",\"lastName\":\"l2-MyLastName-10h\",\"alias\":\"f29-e-10h\"},\"status\":\"organizer\"},{\"attendeeId\":\"d4f7a1cd-e0c1-4988-bdc3-08c34c67cfba\",\"person\":{\"personId\":\"fc129453-5472-4794-80f5-af6c9ae31fdc\",\"firstName\":\"z0-myFirstName-18n\",\"lastName\":\"w22-MyLastName-4n\",\"alias\":\"z0-mme-4n\"},\"status\":\"accepted\"},{\"attendeeId\":\"a48d7c09-a1a8-491c-9b05-09a5d2eefd45\",\"person\":{\"personId\":\"64bb5893-0b77-4f59-bd7c-56855f58e52c\",\"firstName\":\"w18-myFirstName-0k\",\"lastName\":\"i19-MyLastName-22o\",\"alias\":\"w18-e-22o\"},\"status\":\"accepted\"},{\"attendeeId\":\"e0066080-84bd-4440-aeaf-2b3b776e68ca\",\"person\":{\"personId\":\"0860247a-9aae-4c94-887b-a9e85563b218\",\"firstName\":\"z10-myFirstName-25w\",\"lastName\":\"v29-MyLastName-14t\",\"alias\":\"z10-e-14t\"},\"status\":\"accepted\"}]}" as AnyObject
    }
    
    func eventIdForTest() -> String {
        return "2252bcaf-21f4-4c23-901c-b928f5ad189b"
    }
}
