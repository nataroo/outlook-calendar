//
//  UXUtil.swift
//  OutlookCalendar
//
//  Created by Roopa Natarajan on 3/31/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation
import UIKit

class UXUtil: NSObject {
    
    static func createHorizontalConstraints(_ innerView: UIView, outerView: UIView, margin: CGFloat) {
        outerView.addConstraint(NSLayoutConstraint(
            item: innerView,
            attribute: .left,
            relatedBy: .equal,
            toItem: outerView,
            attribute: .left,
            multiplier: 1.0,
            constant: margin))
        
        outerView.addConstraint(NSLayoutConstraint(
            item: innerView,
            attribute: .right,
            relatedBy: .equal,
            toItem: outerView,
            attribute: .right,
            multiplier: 1.0,
            constant: -margin))
    }
    
    static func createVerticalConstraints(_ innerView: UIView, outerView: UIView, margin: CGFloat) {
        outerView.addConstraint(NSLayoutConstraint(
            item: innerView,
            attribute: .top,
            relatedBy: .equal,
            toItem: outerView,
            attribute: .top,
            multiplier: 1.0,
            constant: margin))
        
        outerView.addConstraint(NSLayoutConstraint(
            item: innerView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: outerView,
            attribute: .bottom,
            multiplier: 1.0,
            constant: -margin))
    }
    
    static func createConstraint(
        _ from: UIView,
        parent: UIView,
        to: UIView?,
        constraint: NSLayoutAttribute,
        margin: CGFloat,
        relatedBy: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(
            item: from,
            attribute: constraint,
            relatedBy: relatedBy,
            toItem: to,
            attribute: constraint,
            multiplier: 1,
            constant: margin)
        parent.addConstraint(constraint)
        return constraint
    }
    
    static func createHeightConstraint(_ view: UIView, height: CGFloat) -> NSLayoutConstraint? {
        let constraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[myView(==\(height))]",
            options: NSLayoutFormatOptions(),
            metrics: nil,
            views: ["myView": view])
        view.addConstraints(constraints)
        return constraints.first
    }
    
    static func createWidthConstraint(_ view: UIView, width: CGFloat) -> NSLayoutConstraint? {
        let constraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[myView(==\(width))]",
            options: NSLayoutFormatOptions(),
            metrics: nil,
            views: ["myView": view])
        view.addConstraints(constraints)
        return constraints.first
    }
    
    // Creates constraint to align the bottomView under the topView
    static func createBottomViewToTopViewConstraint(
        _ bottomView: UIView,
        parent: UIView,
        topView: UIView?,
        margin: CGFloat,
        priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(
            item: bottomView,
            attribute: .top,
            relatedBy: .equal,
            toItem: topView,
            attribute: .bottom,
            multiplier: 1,
            constant: margin)
        if let priority = priority {
            constraint.priority = priority
        }
        parent.addConstraint(constraint)
        return constraint
    }
    
    // Creates constraint to align trailingView after leadingView horizontally
    static func createTrailingViewToLeadingViewConstraint(_ trailingView: UIView, parent: UIView, leadingView: UIView, margin: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(
            item: trailingView,
            attribute: .leading,
            relatedBy: .equal,
            toItem: leadingView,
            attribute: .trailing,
            multiplier: 1,
            constant: margin)
        parent.addConstraint(constraint)
        return constraint
    }
    
    static func centerView(_ innerView: UIView, outerView: UIView, parent: UIView? = nil, x: Bool = true, y: Bool = true) {
        if x {
            (parent ?? outerView).addConstraint(NSLayoutConstraint(
                item: innerView,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: outerView,
                attribute: .centerX,
                multiplier: 1,
                constant: 0))
        }
        if y {
            (parent ?? outerView).addConstraint(NSLayoutConstraint(
                item: innerView,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: outerView,
                attribute: .centerY,
                multiplier: 1,
                constant: 0))
        }
    }
}

