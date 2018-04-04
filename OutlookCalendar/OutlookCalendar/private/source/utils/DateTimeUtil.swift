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
    
    // Util to convert UTC date time to user's local time zone date time
    static func UTCToLocal(date: Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = yearFromDate(date: date)
        dateComponents.month = monthFromDate(date: date)
        dateComponents.day = dayFromDate(date: date)
        dateComponents.hour = hourFromDate(date: date)
        dateComponents.minute = minuteFromDate(date: date)
        dateComponents.second = secondFromDate(date: date)

        dateComponents.timeZone = TimeZone.current
        return calendar.date(from: dateComponents)!
    }
    
    static func dateFromValues(year: Int, month: Int, day: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
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
        let date: Date = UTCToLocal(date: Date())
        return yearFromDate(date: date)
    }
    
    static func currentMonth() -> Int {
        let date: Date = UTCToLocal(date: Date())
        return monthFromDate(date: date)
    }
    
    static func numberOfWeekDays() -> Int {
        return calendar.weekdaySymbols.count
    }
}
