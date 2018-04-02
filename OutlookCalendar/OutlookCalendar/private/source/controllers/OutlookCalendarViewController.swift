//
//  OutlookCalendarViewController.swift
//  OutlookCalendar
//
//  Created by Roopa Natarajan on 4/2/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit

class OutlookCalendarViewController: UIViewController {
    
    private var calendarVC = CalendarCollectionViewController()
    private var agendaVC = AgendaTableViewController(style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.calendarVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.agendaVC.view.translatesAutoresizingMaskIntoConstraints = false
//        let navBarHeight = self.navigationController?.navigationBar.frame.height
//        self.view.frame = CGRect(x: 0, y: 88, width: UIScreen.main.bounds.width, height: 724)
        self.view.backgroundColor = UIColor.white
        self.addChildViewController(calendarVC)
        self.view.addSubview(calendarVC.view)
        UXUtil.createHorizontalConstraints(calendarVC.view, outerView: self.view, margin: 0)
        
        self.addChildViewController(agendaVC)
        self.view.addSubview(agendaVC.view)
        UXUtil.createHorizontalConstraints(agendaVC.view, outerView: self.view, margin: 0)
        
        UXUtil.createConstraint(calendarVC.view, parent: self.view, to: self.view, constraint: .top, margin: 0)
        UXUtil.createConstraint(agendaVC.view, parent: self.view, to: self.view, constraint: .bottom, margin: 0)
        UXUtil.createBottomViewToTopViewConstraint(agendaVC.view, parent: self.view, topView: calendarVC.view, margin: 0)
    }
}
