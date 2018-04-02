//
//  AgendaTableViewController.swift
//  OutlookCalendar
//
//  Created by Roopa Natarajan on 3/31/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation
import UIKit

class AgendaTableViewController: UITableViewController {
    
    public weak var agendaDelegate: AgendaDelegate?
    private var selectedDate: String = "1"
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
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
        return 700
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(section + 1)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = "Dummy event"
        let cell = tableView.dequeueReusableCell(withIdentifier: EventViewCell.id, for: indexPath)
        (cell as? EventViewCell)?.setup(data: data)
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
            if let indexPath = self.tableView.indexPathsForVisibleRows?.first {
                // Inform the delegate that user scrolled to a date in AgendaVC
                delegate.didScrollToDate(data: String(indexPath[0] + 1))
            }
        }
    }
    
    func selectDate(data: String) {
        self.selectedDate = data
        DispatchQueue.main.async {
            if let secNumber = Int(self.selectedDate) {
                let indexPath = IndexPath(item: 0, section: secNumber - 1)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
}
