//
//  EventInfo.swift
//  OutlookCalendar
//
//  Created by Roopa Natarajan on 4/3/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation

class EventInfo {
    public var title: String
    public var description: String
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}
