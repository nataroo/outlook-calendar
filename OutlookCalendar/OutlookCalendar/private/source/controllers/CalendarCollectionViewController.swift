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
    // Flag used to avoid a feedback loop in scrolling (differentiates between a user action
    // and a programmatic action)
    public var didUserSelectInCalendar: Bool?
    // Date that the user has selected in the calendar currently
    private var selectedDate: Date
    // Month and year that the user is scrolling through currently (without selecting)
    private var scrollingMonth: Int
    private var scrollingYear: Int
    private var dates: [Date]
    private var numberOfWeekDays = DateTimeUtil.numberOfWeekDays()
    
    init(dates: [Date]) {
        self.dates = dates
        self.selectedDate = Calendar.current.startOfDay(for: Date())
        self.scrollingYear = DateTimeUtil.yearFromDate(date: self.selectedDate)
        self.scrollingMonth = DateTimeUtil.monthFromDate(date: self.selectedDate)
        // Create a custom flow layout since we need separators drawn as decorator views
        let flowLayout = CustomFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 1
        // TODO: Bug - This is supposed to pin the header to the top while scrolling, but doesn't work
        // flowLayout.sectionHeadersPinToVisibleBounds = true
        super.init(collectionViewLayout: flowLayout)
        
        // Register the cell view
        self.collectionView?.register(CalendarViewCell.self, forCellWithReuseIdentifier: CalendarViewCell.id)
        // Register the header view (only for first section)
        self.collectionView?.register(WeekHeaderView.self,
                                        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                        withReuseIdentifier: WeekHeaderView.id)
        self.collectionView?.isScrollEnabled = true
        self.collectionView?.backgroundColor = UIColor.clear
        // Set height constraint for the collection view
        // TODO - Put these into a constants file, so it could also be used in test files
        self.heightConstraint = UXUtil.createHeightConstraint(self.view, height: 150)
        // TODO - Move this to a constants file to be used by test
        self.collectionView?.accessibilityIdentifier = "Calendar-View"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = self.indexPathInDatasource(of: self.selectedDate) {
            self.collectionView?.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
            if let delegate = self.calendarDelegate {
                delegate.didCalendarSelectDate(date: self.selectedDate)
            }
            self.changeNavigationBarTitle(date: self.selectedDate)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // We need 7 columns for the calendar (Sunday -> Saturday)
        return self.numberOfWeekDays
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Number of rows is total number of dates / 7
        return self.dates.count / self.numberOfWeekDays
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // We have a 1d array of dates, but the display is a 2d collection view
        // for each index path, multiply the row index by 7 and add the col index to it to get the index of date in 1d array
        let date = self.dates[indexPath[0] * self.numberOfWeekDays + indexPath[1]]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarViewCell.id, for: indexPath)
        (cell as? CalendarViewCell)?.setup(date: date)
        var isSelected = false
        // Check if the current cell is the selected cell, to change background accordingly
        if date.compare(self.selectedDate) == ComparisonResult.orderedSame {
            isSelected = true
        }
        cell.backgroundColor = isSelected ? UIColor.blue : UIColor.white
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Record that this was a specific user action to select this cell
        self.didUserSelectInCalendar = true
        let date = self.dates[indexPath[0] * self.numberOfWeekDays + indexPath[1]]
        self.selectedDate = date
        // Inform the delegate that user selected a date
        if let delegate = self.calendarDelegate {
            delegate.didCalendarSelectDate(date: date)
        }
        // We changed the selected cell, so reload the data so that backgroundColor of selected cell can change
        self.collectionView?.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Define each cell as a square, width is the total available frame / 7
        // set height to be the same as width
        let itemWidth = (self.collectionView!.frame.width) / CGFloat(self.numberOfWeekDays)
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // We need a header only for the first section
        if section == 0 {
            return CGSize(width: self.collectionView!.frame.width, height: 54)
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
        // User wants to scroll through the calendar, expand it
        self.expandOrCollapse(height: 300)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // As user scrolls thru the calendar, take the currently visible first date and find out which
        // month and year it belongs to
        if let indexPaths = self.collectionView?.indexPathsForVisibleItems {
            if indexPaths.count > 0 {
                let indexPath = indexPaths[0]
                let date = self.dates[indexPath[0] * self.numberOfWeekDays + indexPath[1]]
                self.changeNavigationBarTitle(date: date)
            }
        }
    }

    // TODO: override scrollViewDidScroll method and track the current month being shown in the calendar
    // based on indexPathsOfVisibleCells.  Set the navigation bar's title accordingly
    
    public func expandOrCollapse(height: CGFloat) {
        // Expand or collapse the calendar collection view depending on height
        DispatchQueue.main.async {
            if let heightConstraint = self.heightConstraint {
                UIView.animate(
                    withDuration: 5,
                    delay: 0,
                    options: UIViewAnimationOptions.repeat,
                    animations: {
                        heightConstraint.constant = height
                    }, completion: nil
                )
            }
        }
    }
    
    func selectDate(date: Date) {
        self.selectedDate = date
        // This gets called when user scrolls to a date on AgendaVC
        // But it could also be called when user selects a cell in CalendarVC and so AgendaVC scrolls as a result of that
        // Make sure this is not a user action in calendarVC, but a user action in AgendaVC, otherwise we will get into
        // a scroll feedback loop
        if self.didUserSelectInCalendar == false {
            if let indexPath = self.indexPathInDatasource(of: date) {
                DispatchQueue.main.async {
                    self.collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredVertically, animated: true)
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    
    func indexPathInDatasource(of date: Date) -> IndexPath? {
        if let index = self.dates.index(of: date) {
            var indexPath = IndexPath()
            indexPath.append(index / 7)
            indexPath.append(index % 7)
            return indexPath
        }
        return nil
    }

    // TODO - Currently I am changing the navigation bar's title whenever user scrolls thru the calendar
    // without selecting any date.  This might be confusing because the calendar could display dates from
    // two months at the same time (25 to 30 of a month and 1 to 25 of the next one).  I am choosing the
    // middle row's date right now.  What would be ideal is to change the title only when the user selects
    // a date.  But show the currently scrolling date within the calendar itself as an overlay (like how
    // Outlook calendar does it currently)
    func changeNavigationBarTitle(date: Date) {
        let month = DateTimeUtil.monthFromDate(date: date)
        let year = DateTimeUtil.yearFromDate(date: date)
        // Change the nav bar title only if it is different from what is displayed currently
        var shouldChangeTitle = false
        if month != self.scrollingMonth {
            self.scrollingMonth = month
            shouldChangeTitle = true
        }
        if year != self.scrollingYear {
            self.scrollingYear = year
            shouldChangeTitle = true
        }
        if shouldChangeTitle {
            let monthStr = Calendar.current.monthSymbols[self.scrollingMonth - 1]
            // Display year only if it is not the current year
            let shouldDisplayYear = self.scrollingYear != DateTimeUtil.currentYear()
            (UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.visibleViewController?.title = monthStr + (shouldDisplayYear ? " " + String(self.scrollingYear) : "")
        }
    }
}

