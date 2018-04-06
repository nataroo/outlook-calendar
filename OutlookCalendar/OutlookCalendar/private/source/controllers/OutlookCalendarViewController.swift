//
//  OutlookCalendarViewController.swift
//  OutlookCalendar
//
//  Created by Roopa Natarajan on 4/2/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit

protocol CalendarDelegate: class {
    // Called when user selects a date in the calendar
    func didCalendarSelectDate(date: Date)
}

protocol AgendaDelegate: class {
    // Called when user starts scrolling in the agenda view
    func willAgendaViewBeginScroll()
    // Called when user scrolls to a date in the agenda view
    func didScrollToDate(date: Date)
}

class OutlookCalendarViewController: UIViewController, CalendarDelegate, AgendaDelegate {
    
    private var calendarVC: CalendarCollectionViewController
    private var agendaVC: AgendaTableViewController
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        var dates: [Date] = []
        // Assumption - We have server json data for 3 years starting 2017 ending 2019
        var startDate = DateTimeUtil.dateFromValues(year: 2017, month: 1, day: 1, hour: 0, minute: 0, second: 0)
        var nextDate = startDate
        var endDate = DateTimeUtil.dateFromValues(year: 2019, month: 12, day: 31, hour: 0, minute: 0, second: 0)
        // Create a list of dates from Jan 1 2017 to Dec 31 2019
        while (nextDate.compare(endDate) != ComparisonResult.orderedSame) {
            dates.append(nextDate)
            nextDate = Calendar.current.date(byAdding: .day, value: 1, to: nextDate)!
        }
        // Jan 1 2017 could be a middle of the week day.  Populate the array from the previous Sunday
        var startWeekDay = DateTimeUtil.weekdayFromDate(date: startDate)
        while (startWeekDay > 1) {
            let dateToInsert = Calendar.current.date(byAdding: .day, value: -1, to: startDate)!
            dates.insert(dateToInsert, at: 0)
            startDate = dateToInsert
            startWeekDay -= 1
        }
        // Dec 31 2019 could be a middle of the week day.  Populate the array until the next Saturday
        var endWeekDay = DateTimeUtil.weekdayFromDate(date: endDate)
        while (endWeekDay < 7) {
            let dateToInsert = Calendar.current.date(byAdding: .day, value: 1, to: endDate)!
            dates.append(dateToInsert)
            endDate = dateToInsert
            endWeekDay += 1
        }
        self.calendarVC = CalendarCollectionViewController(dates: dates)
        self.agendaVC = AgendaTableViewController(style: .plain, dates: dates)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.calendarVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.agendaVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = UIColor.white
        
        // Add calendar view controller as a sub view and set its delegate
        self.addChildViewController(calendarVC)
        self.view.addSubview(calendarVC.view)
        // CalendarVC should fill up entire self.view's width
        UXUtil.createHorizontalConstraints(calendarVC.view, outerView: self.view, margin: 0)
        self.calendarVC.calendarDelegate = self
        
        // Add agenda view controller as a sub view and set its delegate
        self.addChildViewController(agendaVC)
        self.view.addSubview(agendaVC.view)
        // AgendaVC should fill up entire self.view's width
        UXUtil.createHorizontalConstraints(agendaVC.view, outerView: self.view, margin: 0)
        self.agendaVC.agendaDelegate = self
        
        // CalendarVC.top = self.view.top
        UXUtil.createConstraint(calendarVC.view, parent: self.view, to: self.view, constraint: .top, margin: 0)
        // AgendaVC.bottom = self.view.bottom
        UXUtil.createConstraint(agendaVC.view, parent: self.view, to: self.view, constraint: .bottom, margin: 0)
        // CalendarVC.bottom = AgendaVC.top
        UXUtil.createBottomViewToTopViewConstraint(agendaVC.view, parent: self.view, topView: calendarVC.view, margin: 20)
    }

    func didCalendarSelectDate(date: Date) {
        // User selected a date in calendar, inform AgendaVC, so that it can scroll to that date
        self.agendaVC.selectDate(date: date)
    }
    
    func willAgendaViewBeginScroll() {
        // User started scrolling in AgendaVC, inform CalendarVC, so that it can resize
        self.calendarVC.expandOrCollapse(height: 150)
        self.calendarVC.didUserSelectInCalendar = false
    }
    
    func didScrollToDate(date: Date) {
        // User scrolled to a date in AgendaVC, inform CalendarVC, so that it can update it's selection
        self.calendarVC.selectDate(date: date)
    }
}
