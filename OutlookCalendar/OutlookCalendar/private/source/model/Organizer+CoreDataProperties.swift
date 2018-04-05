//
//  Organizer+CoreDataProperties.swift
//  OutlookCalendar
//
//  Created by Roopa Natarajan on 4/4/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//
//

import Foundation
import CoreData


extension Organizer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Organizer> {
        return NSFetchRequest<Organizer>(entityName: "Organizer")
    }

    @NSManaged public var event: Event?
    @NSManaged public var person: Person?

}
