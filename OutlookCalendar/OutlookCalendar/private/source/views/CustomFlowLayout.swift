//
//  CustomFlowLayout.swift
//  OutlookCalendar
//
//  Created by Roopa Natarajan on 3/31/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation
import UIKit

private let separatorDecorationView = "separator"

// Custom UICollectionViewFlowLayout to handle separator line as decoration view

class CustomFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        register(SeparatorView.self, forDecorationViewOfKind: separatorDecorationView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // Get all layout attributes
        let layoutAttributes = super.layoutAttributesForElements(in: rect) ?? []
        let lineWidth = self.minimumLineSpacing
        
        var decorationAttributes: [UICollectionViewLayoutAttributes] = []
        
        // Don't draw a separator for the first section (header will do that)
        for layoutAttribute in layoutAttributes where layoutAttribute.indexPath[0] != 0 {
            let separatorAttribute = UICollectionViewLayoutAttributes(forDecorationViewOfKind: separatorDecorationView,
                                                                      with: layoutAttribute.indexPath)
            let cellFrame = layoutAttribute.frame
            // Attributes for the separator line
            separatorAttribute.frame = CGRect(x: cellFrame.origin.x,
                                              y: cellFrame.origin.y - lineWidth,
                                              width: cellFrame.size.width,
                                              height: lineWidth)
            separatorAttribute.zIndex = Int.max
            decorationAttributes.append(separatorAttribute)
        }
        // Return existing attributes plus newly created ones for separator
        return layoutAttributes + decorationAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
