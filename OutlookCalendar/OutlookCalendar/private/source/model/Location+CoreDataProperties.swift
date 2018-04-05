//
//  Location+CoreDataProperties.swift
//  OutlookCalendar
//
//  Created by Roopa Natarajan on 4/4/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var buildingNumber: String?
    @NSManaged public var roomNumber: String?
    @NSManaged public var locationId: String?
    @NSManaged public var event: Event?

}
