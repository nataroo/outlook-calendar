//
//  ViewController.swift
//  OutlookCalendar
//
//  Created by Roopa Natarajan on 3/31/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var calendarVC = CalendarCollectionViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addChildViewController(calendarVC)
        self.view.addSubview(calendarVC.view)
        UXUtil.createHorizontalConstraints(calendarVC.view, outerView: self.view, margin: 0)
    }
}
