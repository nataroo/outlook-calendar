//
//  Event+CoreDataProperties.swift
//  OutlookCalendar
//
//  Created by Roopa Natarajan on 4/4/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var eventTitle: String?
    @NSManaged public var eventDescription: String?
    @NSManaged public var eventTimeUTC: String?
    @NSManaged public var eventTimeLocal: NSDate?
    @NSManaged public var eventDuration: String?
    @NSManaged public var eventId: String?
    @NSManaged public var location: Location?
    @NSManaged public var organizer: Person?
    @NSManaged public var attendees: NSSet?

}

// MARK: Generated accessors for attendees
extension Event {

    @objc(addAttendeesObject:)
    @NSManaged public func addToAttendees(_ value: Attendee)

    @objc(removeAttendeesObject:)
    @NSManaged public func removeFromAttendees(_ value: Attendee)

    @objc(addAttendees:)
    @NSManaged public func addToAttendees(_ values: NSSet)

    @objc(removeAttendees:)
    @NSManaged public func removeFromAttendees(_ values: NSSet)

}
