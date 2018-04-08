//
//  OutlookCalendarUITests.swift
//  OutlookCalendarUITests
//
//  Created by Roopa Natarajan on 3/31/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import XCTest

class OutlookCalendarUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCalendarHeight() {
        let calendarView = XCUIApplication().collectionViews["Calendar-View"]
        // Initially the height is 150
        XCTAssert(calendarView.frame.size.height == 150)
        calendarView.swipeUp()
        
        // When user swipes, calendar view should grow and height should be 300
//        XCTAssert(calendarView.frame.size.height == 300)
    }
    
/*
 Here I wanted to find the calendar collection view, swipe up, find where I had swiped to,
 and then figure out if the table view had also scrolled to show that date.  The below code
 finds the calendar view and swipes it up, but that doesn't trigger a feedback in the tableview
 The tableview doesn't scroll up, so I am unable to test my intention here, not sure what I am missing
 */
    
    func testAgendaViewScroll() {
//        let calendarView = XCUIApplication().collectionViews["Calendar-View"]
//        let agendaView = XCUIApplication().tables["Agenda-View"]
//        agendaView.swipeUp()
    }
    
/*
 Intention of this test is to overcome some limitation of the previous test.  I have hard-coded a specific
 date's cell both in the collection view and the table view.  I will find the collection view cell, tap it
 and then find the table view cell and check if it is now hittable (it would be if the table view scrolled)
 When the test runs, I can see on the UI that the table view scrolled and the cell is now on top
 But the test fails, because apparently multiple matches were found for "Mar-29-Test-TableCell".  I am not
 sure how that is possible, since I am setting that identifier for only one date.
     
 There are also other limitations with this test.  I first need to choose a date that is currently visible
 in the collection view.  Otherwise that date is not tappable, so this test would eventually fail a week or so
 after it has been written and the date has to be updated continously.  The actual fix would be to scroll the
 collection view to a specific date and then perform this test
 */
    func testCalendarDateSelect() {
        // Tap the Mar 29, 2018 cell in calendar view
//        let calendarView = XCUIApplication().collectionViews["Calendar-View"]
//        XCUIApplication().collectionViews.cells["Mar-29-Test-Cell"].tap()
//        let tableCell = XCUIApplication().tables.cells["Mar-29-Test-TableCell"]
//        XCTAssert(tableCell.isHittable)
    }
}
