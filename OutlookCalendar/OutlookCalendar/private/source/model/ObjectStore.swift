//
//  ObjectStore.swift
//  OutlookCalendar
//
//  Created by Roopa Natarajan on 4/4/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import CoreData
import Foundation

class ObjectStore: NSObject {
    
    // Singleton
    static let sharedInstance = ObjectStore()
    private override init() {}

    func eventEntityFrom(elementInfo: AnyObject) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        // Get the id from json and check if we already have a location with that Id in our database
        guard let eventId = elementInfo["eventId"] as? String else { return nil }
        var eventObject: Event? = nil
        do {
            let fetchRequest : NSFetchRequest<Event> = Event.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "eventId == %@", eventId)
            let fetchedResults = try context.fetch(fetchRequest)
            // If we have a location with that Id, reuse that object
            if let anEvent = fetchedResults.first {
                eventObject = anEvent
            }
        }
        catch {
            print ("fetch task failed", error)
        }
        if eventObject == nil {
            // We didn't have that locationId in our database, create a new object
            eventObject = NSEntityDescription.insertNewObject(forEntityName: "Event", into: context) as? Event
        }
        // Update the properties either way, details could've changed for the same location, assuming API keeps the id constant
        eventObject?.eventId = eventId
        eventObject?.eventTitle = elementInfo["eventTitle"] as? String
        eventObject?.eventDescription = elementInfo["eventDescription"] as? String
        eventObject?.eventTimeUTC = elementInfo["eventTimeUTC"] as? String
        eventObject?.eventDuration = elementInfo["eventDuration"] as? String
        let locationObject = locationEntityFrom(elementInfo: elementInfo) as? Location
        eventObject?.location = locationObject
        
        // Add attendees to the event
        if let attendeesElement = elementInfo["attendees"] as? [AnyObject] {
            for attendeeElement in attendeesElement {
                if let attendeeObject = attendeeEntityFrom(elementInfo: attendeeElement) as? Attendee {
                    eventObject?.addToAttendees(attendeeObject)
                }
            }
        }
        return eventObject
    }
    
    func locationEntityFrom(elementInfo: AnyObject) -> NSManagedObject? {
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
    
    func personEntityFrom(elementInfo: AnyObject) -> NSManagedObject? {
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
    
    func attendeeEntityFrom(elementInfo: AnyObject) -> NSManagedObject? {
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
        if let personObject = personEntityFrom(elementInfo: elementInfo) as? Person {
            attendeeObject?.person = personObject
        }
        attendeeObject?.status = elementInfo["status"] as? String
        attendeeObject?.attendeeId = attendeeId
        return attendeeObject
    }
}
