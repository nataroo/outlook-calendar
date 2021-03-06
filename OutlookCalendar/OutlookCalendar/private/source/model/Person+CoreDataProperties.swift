//
//  Person+CoreDataProperties.swift
//  OutlookCalendar
//
//  Created by Roopa Natarajan on 4/5/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var alias: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var personId: String?
    @NSManaged public var attendee: Attendee?

}
