//
//  OutlookCalendarViewController.swift
//  OutlookCalendar
//
//  Created by Roopa Natarajan on 4/2/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit

protocol CalendarDelegate: class {
    func didCalendarSelectDate(data: String)
}

protocol AgendaDelegate: class {
    func willAgendaViewBeginScroll()
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
        self.addChildViewController(calendarVC)
        self.view.addSubview(calendarVC.view)
        UXUtil.createHorizontalConstraints(calendarVC.view, outerView: self.view, margin: 0)
        self.calendarVC.calendarDelegate = self
        
        self.addChildViewController(agendaVC)
        self.view.addSubview(agendaVC.view)
        UXUtil.createHorizontalConstraints(agendaVC.view, outerView: self.view, margin: 0)
        self.agendaVC.agendaDelegate = self
        
        UXUtil.createConstraint(calendarVC.view, parent: self.view, to: self.view, constraint: .top, margin: 0)
        UXUtil.createConstraint(agendaVC.view, parent: self.view, to: self.view, constraint: .bottom, margin: 0)
        UXUtil.createBottomViewToTopViewConstraint(agendaVC.view, parent: self.view, topView: calendarVC.view, margin: 20)
    }
    
    func didCalendarSelectDate(data: String) {
        self.agendaVC.selectDate(data: data)
    }
    
    func willAgendaViewBeginScroll() {
        self.calendarVC.expandOrCollapse(height: 150)
        self.calendarVC.didUserSelectInCalendar = false
    }
    
    func didScrollToDate(data: String) {
        self.calendarVC.selectDate(data: data)
    }
}
