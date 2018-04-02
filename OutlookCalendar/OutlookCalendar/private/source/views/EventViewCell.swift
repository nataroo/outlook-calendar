//
//  EventViewCell.swift
//  OutlookCalendar
//
//  Created by Roopa Natarajan on 4/1/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation
import UIKit

class EventViewCell: UITableViewCell {
    static let id = NSStringFromClass(EventViewCell.self)
    
    private var label = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupLayout()
    }
    
    func setupLayout() {
        self.addSubview(self.label)
        self.label.frame = self.frame
        UXUtil.createHorizontalConstraints(label, outerView: self, margin: 0)
        UXUtil.createVerticalConstraints(label, outerView: self, margin: 0)
        self.label.textAlignment = NSTextAlignment.center
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.prepareForReuse()
    }
    
    func setup(data: String) {
        self.label.text = data
        self.label.textColor = UIColor.black
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.label.text = nil
    }
}
