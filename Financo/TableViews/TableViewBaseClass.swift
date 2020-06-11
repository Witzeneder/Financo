//
//  TableViewController.swift
//  Financer
//
//  Created by Valentin Witzeneder on 24.08.18.
//  Copyright © 2018 Valentin Witzeneder. All rights reserved.
//

import UIKit
import PopupDialog

class TableViewBaseClass: UITableViewController {
    
    private let cellID = "entryCell"
    private var sortedEntries: [SortedEntry] = []
    private var isIncome = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(title: String, isIncome: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.tableView.dataSource = self
        
        self.isIncome = isIncome
        let change = UIBarButtonItem(title: NSLocalizedString("outcomes.name", comment: ""), style: .plain, target: self, action: #selector(changeTableView(sender:)))
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEntry(sender:)))
        self.navigationItem.leftBarButtonItem = change
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(hex: "#0D3530")
        
        self.navigationItem.rightBarButtonItem = addItem
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(hex: "#0D3530")
        
        self.navigationItem.title = title
        self.tableView.backgroundColor = .white
            
        tableView.register(EntryCell.self, forCellReuseIdentifier: cellID)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addEntry(sender: UIBarButtonItem) {
        let vc = EntryTabBar(isIncome: isIncome)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func changeTableView(sender: UIBarButtonItem) {
        if isIncome {
            self.navigationItem.title = NSLocalizedString("outcomes.name", comment: "")
            sortedEntries = []
            sortedEntries = realmManager.getOutcomesSorted()
            self.navigationItem.leftBarButtonItem?.title = NSLocalizedString("incomes.name", comment: "")
        } else {
            self.navigationItem.title = NSLocalizedString("incomes.name", comment: "")
            sortedEntries = []
            sortedEntries = realmManager.getIncomesSorted()
            self.navigationItem.leftBarButtonItem?.title = NSLocalizedString("outcomes.name", comment: "")
            
        }
        isIncome = !isIncome
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        sortedEntries = []
        
        if isIncome {
            sortedEntries = realmManager.getIncomesSorted()
        } else {
            sortedEntries = realmManager.getOutcomesSorted()
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sortedEntries.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitle = "\(sortedEntries[section].year) \(monthsString[sortedEntries[section].month-1])"
        return sectionTitle
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sortedEntries[section].entries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! EntryCell
        
        cell.textLabel?.text = String(sortedEntries[indexPath.section].entries[indexPath.row].amount) + currency
        cell.textLabel?.textAlignment = .left
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the entry from the realm
            try! myRealm.write {
                myRealm.delete(sortedEntries[indexPath.section].entries[indexPath.row])
            }
            
            // Delete the entry from the sortedEntries
            sortedEntries[indexPath.section].entries.remove(at: indexPath.row)
            if sortedEntries[indexPath.section].entries.count < 1 {
                sortedEntries.remove(at: indexPath.section)
            }
            
            // Finally reload the tableView Data again
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = sortedEntries[indexPath.section].entries[indexPath.row]
        
        let popVC = EntryDetailPopupVC(entry: entry)
        
        let transitionBool = Bool.random()
        var transition = PopupDialogTransitionStyle.bounceUp
        if transitionBool {
            transition = PopupDialogTransitionStyle.bounceDown
        }
        
        let popupDialog = PopupDialog(viewController: popVC, buttonAlignment: .vertical, transitionStyle: transition, preferredWidth: self.view.frame.width * 0.9, tapGestureDismissal: true, panGestureDismissal: true, hideStatusBar: true, completion: nil)
        
        let deleteButton = DestructiveButton(title: NSLocalizedString("buttons.delete", comment: "")) {
            try! myRealm.write {
                myRealm.delete(entry)
                self.sortedEntries[indexPath.section].entries.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
        }
        let button = MyCustomButton(title: NSLocalizedString("buttons.cancel", comment: ""), action: nil)
        
        popupDialog.addButtons([deleteButton,button])
        self.present(popupDialog, animated: true, completion: nil)
    }
}
