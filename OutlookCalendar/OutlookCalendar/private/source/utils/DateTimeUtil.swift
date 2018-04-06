//
//  DateTimeUtil.swift
//  OutlookCalendar
//
//  Created by Roopa Natarajan on 4/3/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation
import UIKit

class DateTimeUtil {
    
    static var calendar = Calendar.current
    
    static func dateFromValues(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        return calendar.date(from: dateComponents)!
    }
    
    static func dayFromDate(date: Date) -> Int {
        return calendar.component(.day, from: date)
    }
    
    static func monthFromDate(date: Date) -> Int {
        return calendar.component(.month, from: date)
    }
    
    static func yearFromDate(date: Date) -> Int {
        return calendar.component(.year, from: date)
    }
    
    static func weekdayFromDate(date: Date) -> Int {
        return calendar.component(.weekday, from: date)
    }
    
    static func hourFromDate(date: Date) -> Int {
        return calendar.component(.hour, from: date)
    }
    
    static func minuteFromDate(date: Date) -> Int {
        return calendar.component(.minute, from: date)
    }

    static func secondFromDate(date: Date) -> Int {
        return calendar.component(.second, from: date)
    }
    
    static func currentYear() -> Int {
        return yearFromDate(date: Date())
    }
    
    static func currentMonth() -> Int {
        return monthFromDate(date: Date())
    }
    
    static func numberOfWeekDays() -> Int {
        return calendar.weekdaySymbols.count
    }
}
