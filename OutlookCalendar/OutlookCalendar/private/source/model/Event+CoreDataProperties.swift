//
//  Event+CoreDataProperties.swift
//  OutlookCalendar
//
//  Created by Roopa Natarajan on 4/5/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var eventDescription: String?
    @NSManaged public var eventDuration: String?
    @NSManaged public var eventId: String?
    @NSManaged public var eventTimeLocal: String?
    @NSManaged public var eventDateTimeUTC: String?
    @NSManaged public var eventTitle: String?
    @NSManaged public var eventDateLocal: String?
    @NSManaged public var attendees: NSSet?
    @NSManaged public var location: Location?

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
