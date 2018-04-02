//
//  WeekHeaderView.swift
//  OutlookCalendar
//
//  Created by Roopa Natarajan on 4/1/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation
import UIKit

class WeekHeaderView: UICollectionReusableView {
    
    static let id = NSStringFromClass(WeekHeaderView.self)
    
    // Days of the week
    private var weekDays: [String] = [ "S", "M", "T", "W", "T", "F", "S" ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Create a horizontal stack view to put 7 labels next to each other
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = UILayoutConstraintAxis.horizontal
        // No gap between the labels
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        // -1 for separator in the bottom
        stackView.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height - 1)
        let width = frame.width / 7
        var index: CGFloat = 0.0
        weekDays.forEach({ (day: String) in
            let label = UILabel()
            label.text = day
            label.textColor = UIColor.black
            label.textAlignment = .center
            label.frame = CGRect(x: index * width, y: 0, width: width, height: width)
            label.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(label)
            UXUtil.createVerticalConstraints(label, outerView: stackView, margin: 0)
            index += 1
        })
        self.addSubview(stackView)
        UXUtil.createHorizontalConstraints(stackView, outerView: self, margin: 0)
        UXUtil.createConstraint(stackView, parent: self, to: self, constraint: .top, margin: 0)
        
        // Add a 1 px separator line below the stack view
        let separatorView = UIView()
        separatorView.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: 1)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = UIColor.lightGray
        self.addSubview(separatorView)
        UXUtil.createHeightConstraint(separatorView, height: 1)
        UXUtil.createHorizontalConstraints(separatorView, outerView: self, margin: 0)
        UXUtil.createBottomViewToTopViewConstraint(separatorView, parent: self, topView: stackView, margin: 0)
        UXUtil.createConstraint(separatorView, parent: self, to: self, constraint: .bottom, margin: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

