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
    func didCalendarSelectDate(data: String)
}

protocol AgendaDelegate: class {
    // Called when user starts scrolling in the agenda view
    func willAgendaViewBeginScroll()
    // Called when user scrolls to a date in the agenda view
    func didScrollToDate(data: String)
}

class OutlookCalendarViewController: UIViewController, CalendarDelegate, AgendaDelegate {
    
    private var calendarVC = CalendarCollectionViewController()
    private var agendaVC = AgendaTableViewController(style: .plain)
    
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
    
    func didCalendarSelectDate(data: String) {
        // User selected a date in calendar, inform AgendaVC, so that it can scroll to that date
        self.agendaVC.selectDate(data: data)
    }
    
    func willAgendaViewBeginScroll() {
        // User started scrolling in AgendaVC, inform CalendarVC, so that it can resize
        self.calendarVC.expandOrCollapse(height: 150)
        self.calendarVC.didUserSelectInCalendar = false
    }
    
    func didScrollToDate(data: String) {
        // User scrolled to a date in AgendaVC, inform CalendarVC, so that it can update it's selection
        self.calendarVC.selectDate(data: data)
    }
}
