//
//  EventViewCell.swift
//  OutlookCalendar
//
//  Created by Roopa Natarajan on 4/1/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation
import UIKit

// Cell class for AgendaTableViewController

class EventViewCell: UITableViewCell {
    static let id = NSStringFromClass(EventViewCell.self)
    
    private var eventView = UIView()
    private var startTimeLabel = UILabel()
    private var durationLabel = UILabel()
    private var titleLabel = UILabel()
    private var attendeesLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isAccessibilityElement = true
        self.setupLayout()
    }
    
    func setupLayout() {
        self.addSubview(self.eventView)
        self.eventView.frame = self.frame
        self.eventView.addSubview(self.startTimeLabel)
        self.eventView.addSubview(self.durationLabel)
        self.eventView.addSubview(titleLabel)
        self.eventView.addSubview(attendeesLabel)
        
        UXUtil.createHorizontalConstraints(self.eventView, outerView: self, margin: 16)
        UXUtil.createVerticalConstraints(self.eventView, outerView: self, margin: 0)
        
        // Pin the start time label to the top left corner of the cell
        UXUtil.createConstraint(self.startTimeLabel, parent: self.eventView, to: self.eventView, constraint: .top, margin: 0)
        UXUtil.createConstraint(self.startTimeLabel, parent: self.eventView, to: self.eventView, constraint: .left, margin: 0)
        UXUtil.createWidthConstraint(self.startTimeLabel, width: 100)
        _ = UXUtil.createHeightConstraint(self.startTimeLabel, height: 40)
        
        // Pin the duration label to the left of the cell and below the start time label
        UXUtil.createConstraint(self.durationLabel, parent: self.eventView, to: self.eventView, constraint: .left, margin: 0)
        UXUtil.createBottomViewToTopViewConstraint(self.durationLabel, parent: self.eventView, topView: self.startTimeLabel, margin: 0)
        UXUtil.createWidthConstraint(self.durationLabel, width: 100)
        _ = UXUtil.createHeightConstraint(self.durationLabel, height: 40)
        
        // Pin the title label to the top of the cell and to the right of the start time label
        UXUtil.createConstraint(self.titleLabel, parent: self.eventView, to: self.eventView, constraint: .top, margin: 0)
        UXUtil.createTrailingViewToLeadingViewConstraint(self.titleLabel, parent: self.eventView, leadingView: self.startTimeLabel, margin: 0)
        _ = UXUtil.createHeightConstraint(self.titleLabel, height: 40)
        UXUtil.createWidthConstraint(self.titleLabel, width: self.frame.width - self.startTimeLabel.frame.width - 30)
        
        // Pin the attendeesLabel below the title label and to the right of duration label
        UXUtil.createBottomViewToTopViewConstraint(self.attendeesLabel, parent: self.eventView, topView: self.titleLabel, margin: 0)
        UXUtil.createTrailingViewToLeadingViewConstraint(self.attendeesLabel, parent: self.eventView, leadingView: self.durationLabel, margin: 0)
        _ = UXUtil.createHeightConstraint(self.attendeesLabel, height: 40)
        UXUtil.createWidthConstraint(self.attendeesLabel, width: self.frame.width - self.durationLabel.frame.width - 30)
        
        self.startTimeLabel.textAlignment = NSTextAlignment.left
        self.startTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.durationLabel.textAlignment = NSTextAlignment.left
        self.durationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel.textAlignment = NSTextAlignment.left
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.attendeesLabel.textAlignment = NSTextAlignment.left
        self.attendeesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.eventView.translatesAutoresizingMaskIntoConstraints = false
        self.prepareForReuse()
    }
    
    func setup(event: Event) {
        self.startTimeLabel.text = event.eventTimeLocal
        self.startTimeLabel.textColor = UIColor.darkText
        
        if let duration = event.eventDuration {
            self.durationLabel.text = duration + "m"
        }
        self.durationLabel.textColor = UIColor.darkText
        
        self.titleLabel.text = event.eventTitle
        self.titleLabel.textColor = UIColor.darkText
        
        // If Harry Potter and Ron Weasley were the attendees, display HP, RW as the attendeesString
        // TODO - We can polish this further by displaying UX to indicate the status of each of these
        // attendees - the API passes status as 'accepted', 'declined', 'none' or 'organizer'
        var attendeesString = ""
        if let attendees = event.attendees {
            for attendee in attendees {
                if let attendee = attendee as? Attendee {
                    let firstChar = attendee.person?.firstName?.first?.description
                    let secondChar = attendee.person?.lastName?.first?.description
                    let str = firstChar!.capitalized + secondChar!.capitalized
                    attendeesString = attendeesString + (attendeesString != "" ? ", " : "") + str
                }
            }
        }
        self.attendeesLabel.text = attendeesString
        self.attendeesLabel.textColor = UIColor.darkText
        // For UI tests
        if event.eventDateLocal == "2018-03-29" {
            self.accessibilityIdentifier = "Mar-29-Test-TableCell"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.startTimeLabel.text = nil
        self.durationLabel.text = nil
        self.titleLabel.text = nil
        self.attendeesLabel.text = nil
    }
}
