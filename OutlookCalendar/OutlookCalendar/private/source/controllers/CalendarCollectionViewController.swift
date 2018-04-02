//
//  CalendarCollectionViewController.swift
//  OutlookCalendar
//
//  Created by Roopa Natarajan on 3/31/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation
import UIKit

class CalendarCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    public weak var calendarDelegate: CalendarDelegate?
    public var heightConstraint: NSLayoutConstraint?
    var selectedDateInAgenda: String = "1" {
        didSet {
            self.didSetDate()
        }
    }
    
    init() {
        let flowLayout = CustomFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 1
        // TODO - This is supposed to pin the header to the top while scrolling, but doesn't work
//        flowLayout.sectionHeadersPinToVisibleBounds = true
        super.init(collectionViewLayout: flowLayout)
        
        self.collectionView?.register(CalendarViewCell.self, forCellWithReuseIdentifier: CalendarViewCell.id)
        self.collectionView?.register(WeekHeaderView.self,
                                        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                        withReuseIdentifier: WeekHeaderView.id)
        self.collectionView?.isScrollEnabled = true
        self.collectionView?.backgroundColor = UIColor.clear
        self.heightConstraint = UXUtil.createHeightConstraint(self.view, height: 200)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 100
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = (indexPath[0] * 7) + indexPath[1] + 1
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarViewCell.id, for: indexPath)
        (cell as? CalendarViewCell)?.setup(data: data)
        var isSelected = false
        
        if Int(self.selectedDateInAgenda) == data {
            isSelected = true
        }
    
        cell.backgroundColor = isSelected ? UIColor.blue : UIColor.white
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = self.calendarDelegate {
            delegate.didCalendarSelectDate(data: String((indexPath[0] * 7) + indexPath[1] + 1))
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 7.0
        let itemWidth = (self.collectionView!.frame.width - (numberOfColumns - 1)) / numberOfColumns
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: UIScreen.main.bounds.width, height: 54)
        }
        return CGSize.zero
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind ==  UICollectionElementKindSectionHeader {
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionElementKindSectionHeader,
                withReuseIdentifier: WeekHeaderView.id,
                for: indexPath)
            return supplementaryView
        }
        return UICollectionReusableView()
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.expandOrCollapse(height: 300)
    }
    
    public func expandOrCollapse(height: CGFloat) {
        DispatchQueue.main.async {
            if let heightConstraint = self.heightConstraint {
                UIView.animate(
                    withDuration: 5,
                    delay: 0,
                    options: UIViewAnimationOptions.repeat,
                    animations: { [weak self]() -> Void in
                        heightConstraint.constant = height
                    }, completion: { _ -> Void in
                })
            }
        }
    }
    
    func didSetDate() {
        let row = Int(self.selectedDateInAgenda)! / 7
        let col = Int(self.selectedDateInAgenda)! % 7
        DispatchQueue.main.async {
            self.collectionView?.scrollToItem(at: IndexPath(item: col, section: row), at: UICollectionViewScrollPosition.centeredVertically, animated: true)
            self.collectionView?.reloadData()
        }
    }
}


