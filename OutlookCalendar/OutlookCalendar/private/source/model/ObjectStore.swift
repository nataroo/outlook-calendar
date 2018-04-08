//  ObjectStore.swift
//  OutlookCalendar
//
//  Created by Roopa Natarajan on 4/4/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import CoreData
import Foundation

/*
 
TODO - There are two approches to updating the Core Data table to avoid duplicates
 a. Everytime an API call is made, delete all entries from the core data model and recreate from json response
 b. Whenever an entity object is created, query the core data model for that entity type using a unique id.  If
    that entity is already available, update it's properties based on json response, otherwise create a new one
 
I have followed option b here.  Drawback with this is, if API deletes some entities in its response the next time, we will
never delete those entity objects from the core data model.  To achieve this, we might have to set a flag on each
object during the API update and delete the ones which were never touched.  Or we could have a contract from the service,
to send the deletion info along with the json response.  Like a 404 not found for that specific id.  But it might not
be scalable for the API to keep sending this for a long time, so ultimately the client has to delete the objects which
are not present in the server response.  I have not done this delete implementation since my data is static and the json
response is always the same
 
 */

class ObjectStore: NSObject {
    
    // Singleton
    static let sharedInstance = ObjectStore()
    private override init() {}

    func createOrUpdateEventEntityFrom(elementInfo: AnyObject) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        // Get the id from json and check if we already have a location with that Id in our database
        guard let eventId = elementInfo["eventId"] as? String else { return nil }
        var eventObject: Event? = nil
        do {
            let fetchRequest : NSFetchRequest<Event> = Event.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "eventId == %@", eventId)
            let fetchedResults = try context.fetch(fetchRequest)
            // If we have an event with that Id, reuse that object
            if let anEvent = fetchedResults.first {
                eventObject = anEvent
            }
        }
        catch {
            print ("fetch task failed", error)
        }
        if eventObject == nil {
            // We didn't have that eventId in our database, create a new object
            eventObject = NSEntityDescription.insertNewObject(forEntityName: "Event", into: context) as? Event
        }
        // Update the properties either way, details could've changed for the same location, assuming API keeps the id constant
        eventObject?.eventId = eventId
        eventObject?.eventTitle = elementInfo["eventTitle"] as? String
        eventObject?.eventDescription = elementInfo["eventDescription"] as? String
        eventObject?.eventDateTimeUTC = elementInfo["eventDateTimeUTC"] as? String
        
        // Convert the datetime from API from UTC to local time zone and save the date and time separately
        // TODO: Bug - Convert UTC To local first
        if let dateTimeArray = eventObject?.eventDateTimeUTC?.components(separatedBy: "T") {
            eventObject?.eventDateLocal = dateTimeArray[0]
            eventObject?.eventTimeLocal = dateTimeArray[1]
        }
        
        eventObject?.eventDuration = elementInfo["eventDuration"] as? String
        let locationObject = createOrUpdateLocationEntityFrom(elementInfo: elementInfo) as? Location
        eventObject?.location = locationObject
        
        // Add attendees to the event
        if let attendeesElement = elementInfo["attendees"] as? [AnyObject] {
            for attendeeElement in attendeesElement {
                if let attendeeObject = createOrUpdateAttendeeEntityFrom(elementInfo: attendeeElement) as? Attendee {
                    eventObject?.addToAttendees(attendeeObject)
                }
            }
        }
        return eventObject
    }
    
    func createOrUpdateLocationEntityFrom(elementInfo: AnyObject) -> NSManagedObject? {
        // Create a location object
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        // Json response for a location
        guard let locationElement = elementInfo["location"] as? AnyObject else { return nil }
        // Get the id from json and check if we already have a location with that Id in our database
        guard let locationId = locationElement["locationId"] as? String else { return nil }
        var locationObject: Location? = nil
        do {
            let fetchRequest : NSFetchRequest<Location> = Location.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "locationId == %@", locationId)
            let fetchedResults = try context.fetch(fetchRequest)
            // If we have a location with that Id, reuse that object
            if let aLocation = fetchedResults.first {
                locationObject = aLocation
            }
        }
        catch {
            print ("fetch task failed", error)
        }
        if locationObject == nil {
            // We didn't have that locationId in our database, create a new object
            locationObject = NSEntityDescription.insertNewObject(forEntityName: "Location", into: context) as? Location
        }
        // Update the properties either way, details could've changed for the same location, assuming API keeps the id constant
        locationObject?.locationId = locationId
        locationObject?.buildingNumber = locationElement["buildingNumber"] as? String
        locationObject?.roomNumber = locationElement["roomNumber"] as? String
        return locationObject
    }
    
    func createOrUpdatePersonEntityFrom(elementInfo: AnyObject) -> NSManagedObject? {
        // Create a person object
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        // Json response for a person
        guard let personElement = elementInfo["person"] as? AnyObject else { return nil }
        // Get the id from json and check if we already have a person with that Id in our database
        guard let personId = personElement["personId"] as? String else { return nil }
        var personObject: Person? = nil
        do {
            let fetchRequest : NSFetchRequest<Person> = Person.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "personId == %@", personId)
            let fetchedResults = try context.fetch(fetchRequest)
            // If we have a person with that Id, reuse that object
            if let aPerson = fetchedResults.first {
                personObject = aPerson
            }
        }
        catch {
            print ("fetch task failed", error)
        }
        if personObject == nil {
            // We didn't have that personId in our database, create a new object
            personObject = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context) as? Person
        }
        // Update the properties either way, details could've changed for the same person, assuming API keeps the id constant
        personObject?.personId = personId
        personObject?.firstName = personElement["firstName"] as? String
        personObject?.lastName = personElement["lastName"] as? String
        personObject?.alias = personElement["alias"] as? String
        return personObject
    }
    
    func createOrUpdateAttendeeEntityFrom(elementInfo: AnyObject) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        guard let attendeeId = elementInfo["attendeeId"] as? String else { return nil }
        var attendeeObject: Attendee? = nil
        do {
            let fetchRequest : NSFetchRequest<Attendee> = Attendee.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "attendeeId == %@", attendeeId)
            let fetchedResults = try context.fetch(fetchRequest)
            // If we have a attendee with that Id, reuse that object
            if let anAttendee = fetchedResults.first {
                attendeeObject = anAttendee
            }
        }
        catch {
            print ("fetch task failed", error)
        }
        if attendeeObject == nil {
            // We didn't have that attendeeId in our database, create a new object
            attendeeObject = NSEntityDescription.insertNewObject(forEntityName: "Attendee", into: context) as? Attendee
        }
        
        // Update the properties either way, details could've changed for the same attendee, assuming API keeps the id constant
        if let personObject = createOrUpdatePersonEntityFrom(elementInfo: elementInfo) as? Person {
            attendeeObject?.person = personObject
        }
        attendeeObject?.status = elementInfo["status"] as? String
        attendeeObject?.attendeeId = attendeeId
        return attendeeObject
    }
    
    func fetchAllEventsOn(date: String) -> [Event]? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        do {
            let fetchRequest : NSFetchRequest<Event> = Event.fetchRequest()
            // TODO - Bug: Change this to eventTimeLocal once that field is populated
            fetchRequest.predicate = NSPredicate(format: "eventDateLocal == %@", date)
            let fetchedResults = try context.fetch(fetchRequest)
            return fetchedResults.count > 0 ? fetchedResults : nil
        }
        catch {
            print ("fetch task failed", error)
        }
        return nil
    }
    
    func fetchEventWithId(id: String) -> Event? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        do {
            let fetchRequest : NSFetchRequest<Event> = Event.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "eventId == %@", id)
            let fetchedResults = try context.fetch(fetchRequest)
            return fetchedResults.first
        }
        catch {
            print ("fetch task failed", error)
        }
        return nil
    }

}
