//
//  CalendarViewCell.swift
//  OutlookCalendar
//
//  Created by Roopa Natarajan on 3/31/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation
import UIKit

// Cell class for CalendarCollectionViewController

class CalendarViewCell: UICollectionViewCell {
    static let id = NSStringFromClass(CalendarViewCell.self)
    
    private var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupLayout()
    }
    
    func setupLayout() {
        self.addSubview(self.label)
        // Align the label to occupy the entire cell
        UXUtil.createHorizontalConstraints(label, outerView: self, margin: 0)
        UXUtil.createVerticalConstraints(label, outerView: self, margin: 0)
        self.label.textAlignment = NSTextAlignment.center
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.prepareForReuse()
    }
    
    func setup(data: Int) {
        self.label.text = String(data)
        self.label.textColor = UIColor.black
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.label.text = nil
    }
}
