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
        var eventObject: Event?
        
        let locationObject = locationEntityFrom(elementInfo: elementInfo) as? Location
        
        let organizerObject = organizerEntityFrom(elementInfo: elementInfo) as? Organizer
        
        // Create the event object
        if let event = NSEntityDescription.insertNewObject(forEntityName: "Event", into: context) as? Event {
            event.eventId = elementInfo["eventId"] as? String
            event.eventTitle = elementInfo["eventTitle"] as? String
            event.eventDescription = elementInfo["eventDescription"] as? String
            event.eventTimeUTC = elementInfo["eventTimeUTC"] as? String
            event.eventDuration = elementInfo["eventDuration"] as? String
            event.location = locationObject
            event.organizer = organizerObject
            
            // Add attendees to the event
            if let attendeesElement = elementInfo["attendees"] as? [AnyObject] {
                for attendeeElement in attendeesElement {
                    let attendeeObject = attendeeEntityFrom(elementInfo: attendeeElement) as? Attendee
                    event.addToAttendees(attendeeObject!)
                }
            }
            eventObject = event
        }
        return eventObject
    }
    
    func locationEntityFrom(elementInfo: AnyObject) -> NSManagedObject? {
        // Create a location object
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let location = NSEntityDescription.insertNewObject(forEntityName: "Location", into: context) as? Location {
            let locationElement = elementInfo["location"] as? AnyObject
            location.locationId = locationElement!["locationId"] as? String
            location.buildingNumber = locationElement!["buildingNumber"] as? String
            location.roomNumber = locationElement!["roomNumber"] as? String
            return location
        }
        return nil
    }
    
    func organizerEntityFrom(elementInfo: AnyObject) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let organizer = NSEntityDescription.insertNewObject(forEntityName: "Organizer", into: context) as? Organizer {
            let organizerElement = elementInfo["organizer"] as? AnyObject
            if let personObject = personEntityFrom(elementInfo: organizerElement!) as? Person {
                organizer.person = personObject
                return organizer
            }
        }
        return nil
    }
    
    func personEntityFrom(elementInfo: AnyObject) -> NSManagedObject? {
        // Create a person object
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let person = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context) as? Person {
            let personElement = elementInfo["person"] as? AnyObject
            person.personId = personElement!["personId"] as? String
            person.firstName = personElement!["firstName"] as? String
            person.lastName = personElement!["lastName"] as? String
            return person
        }
        return nil
    }
    
    func attendeeEntityFrom(elementInfo: AnyObject) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let attendee = NSEntityDescription.insertNewObject(forEntityName: "Attendee", into: context) as? Attendee {
            if let personObject = personEntityFrom(elementInfo: elementInfo) as? Person {
                attendee.person = personObject
            }
            attendee.status = elementInfo["status"] as? String
            attendee.attendeeId = elementInfo["attendeeId"] as? String
            return attendee
        }
        return nil
    }
}

