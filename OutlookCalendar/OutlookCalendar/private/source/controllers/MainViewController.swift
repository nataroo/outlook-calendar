//
//  MainViewController.swift
//  OutlookCalendar
//
//  Created by Roopa Natarajan on 4/2/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let outlookCalendarVC = OutlookCalendarViewController()
        self.addChildViewController(outlookCalendarVC)
        self.view.addSubview(outlookCalendarVC.view)
        UXUtil.createVerticalConstraints(outlookCalendarVC.view, outerView: self.view, margin: 0)
        UXUtil.createHorizontalConstraints(outlookCalendarVC.view, outerView: self.view, margin: 0)
    }
}
