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
    let events: [Event]
    
    init(date: Date, events: [Event]) {
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
    }
    
    func setUpData() {
        self.dataSource.removeAll()
        self.dates.forEach( { (date: Date) in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            // Before making an API call, check if we have some data in core data model and display that to the user first
            if let events = ObjectStore.sharedInstance.fetchAllEventsOn(date: formatter.string(from: date)) {
                self.dataSource.append(Datasource(date: date, events: events))
            } else {
                // If there are no events for a given date, we still want to display the date
                // so insert an empty Event array
                self.dataSource.append(Datasource(date: date, events: [Event]()))
            }
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpData()
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
        // Register the cell for displaying no events
        self.tableView.register(NoEventView.self, forCellReuseIdentifier: NoEventView.id)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // After loading the saved data from core data model, make an API call to update the model with any changes
        // from the server and refresh the views
        self.performAPICall(completion: {
            // API call has been made and data saved to core data
            // Use that data for this view and refresh the view
            self.setUpData()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Number of sections is the total number of dates
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Number of rows in a section is the number of events on a specific date
        // If there are no events on a date, still return 1 row (we will display a 'no events' view)
        return self.dataSource[section].events.count != 0 ? self.dataSource[section].events.count : 1
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
        // Check if there are any events for the given date
        let isNoEventView: Bool = self.dataSource[indexPath[0]].events.count == 0
        // There are events, so display the event information
        if !isNoEventView {
            let event: Event = self.dataSource[indexPath[0]].events[indexPath[1]]
            let cell = tableView.dequeueReusableCell(withIdentifier: EventViewCell.id, for: indexPath)
            (cell as? EventViewCell)?.setup(event: event)
            cell.backgroundColor = UIColor.white
            return cell
        }
        // There are no events for that day, display 'no events'
        let cell = tableView.dequeueReusableCell(withIdentifier: NoEventView.id, for: indexPath)
        (cell as? NoEventView)?.setup()
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

    func performAPICall(completion: (() -> Swift.Void)? = nil) {
        // Assumption: Make an API call here and assume the response is stored in array
        let array = JsonParser.JSONParseArray()
        for elementInfo in array! {
            // Map the json response to the core data model
            _ = ObjectStore.sharedInstance.createOrUpdateEventEntityFrom(elementInfo: elementInfo)
        }
        do {
            // Save the data
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
            // Data has been saved to CoreData, inform the caller in case they want to refresh the UX
            if let completion = completion {
                completion()
            }
        } catch let error {
            print(error)
        }
    }
}
