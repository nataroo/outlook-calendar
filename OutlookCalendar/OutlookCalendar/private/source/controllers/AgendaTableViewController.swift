//
//  AgendaTableViewController.swift
//  OutlookCalendar
//
//  Created by Roopa Natarajan on 3/31/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation
import UIKit

class Datasource  {
    let date: Date
    let events: [EventInfo]
    
    init(date: Date, events: [EventInfo]) {
        self.date = date
        self.events = events
    }
}

class AgendaTableViewController: UITableViewController {
    
    public weak var agendaDelegate: AgendaDelegate?
    private var selectedDate: Date
    private var dates: [Date]
    private var dataSource: [Datasource]
    init(style: UITableViewStyle, dates: [Date]) {
        self.dates = dates
        // By default select user's current date (per local time zone)
        self.selectedDate = DateTimeUtil.UTCToLocal(date: Date())
        self.dataSource = []
        super.init(style: style)
        self.setUpData()
    }
    
    func setUpData() {
        self.dates.forEach( { (date: Date) in
            // TODO - Change this to take events for a specific date from core data after it is implemented
            let event1 = EventInfo(title: "Meeting 1", description: "Scrum meeting")
            let event2 = EventInfo(title: "Meeting 2", description: "Team meeting")
            let events: [EventInfo] = [ event1, event2 ]
            self.dataSource.append(Datasource(date: date, events: events))
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.bounces = false
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.isScrollEnabled = true
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        self.tableView.estimatedRowHeight = 60
        self.tableView.estimatedSectionHeaderHeight = 20
        self.tableView.estimatedSectionFooterHeight = 0
        // Register the event view cell
        self.tableView.register(EventViewCell.self, forCellReuseIdentifier: EventViewCell.id)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Number of sections is the total number of dates
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Number of rows in a section is the number of events on a specific date
        return self.dataSource[section].events.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let formatter = DateFormatter()
        let date = self.dataSource[section].date
        let weekDay: String = formatter.weekdaySymbols[DateTimeUtil.weekdayFromDate(date: date) - 1]
        let month: String = formatter.shortMonthSymbols[(DateTimeUtil.monthFromDate(date: date)) - 1]
        let day: String = String(DateTimeUtil.dayFromDate(date: date))
        var year: String = String(DateTimeUtil.yearFromDate(date: date))
        // Display year only if it is not the current year
        if (year == String(DateTimeUtil.currentYear())) {
            year = ""
        }
        return weekDay + ", " + month + " " + day + (year != "" ? ", " + year : "")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event: EventInfo = self.dataSource[indexPath[0]].events[indexPath[1]]
        let cell = tableView.dequeueReusableCell(withIdentifier: EventViewCell.id, for: indexPath)
        (cell as? EventViewCell)?.setup(event: event)
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let delegate = self.agendaDelegate {
            // Inform the delegate that user started scrolling in AgendaVC
            delegate.willAgendaViewBeginScroll()
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let delegate = self.agendaDelegate {
            // As the user scrolls, take the first date that is visible
            if let indexPath = self.tableView.indexPathsForVisibleRows?.first {
                // Inform the delegate that user scrolled to a date in AgendaVC
                delegate.didScrollToDate(date: self.dataSource[indexPath[0]].date)
            }
        }
    }
    
    func selectDate(date: Date) {
        // This will be called when user selects a date in the calendar
        // Scroll this view so that the selected date appears on top
        self.selectedDate = date
        DispatchQueue.main.async {
            if let secNumber = self.dates.index(of: date) {
                let indexPath = IndexPath(item: 0, section: secNumber)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
}
