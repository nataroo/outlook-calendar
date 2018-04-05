//
//  Attendee+CoreDataProperties.swift
//  OutlookCalendar
//
//  Created by Roopa Natarajan on 4/5/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//
//

import Foundation
import CoreData


extension Attendee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Attendee> {
        return NSFetchRequest<Attendee>(entityName: "Attendee")
    }

    @NSManaged public var attendeeId: String?
    @NSManaged public var status: String?
    @NSManaged public var event: Event?
    @NSManaged public var person: Person?

}
