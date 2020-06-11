//
//  RealmObjects+HelperStructs.swift
//  Financer
//
//  Created by Valentin Witzeneder on 25.08.18.
//  Copyright © 2018 Valentin Witzeneder. All rights reserved.
//

import Foundation
import RealmSwift

@objc enum EntryType: Int {
    case IncomeSingle = 1
    case IncomeMonthly = 2
    case IncomeCustom = 3
    case OutcomeSingle = 4
    case OutcomeMonthly = 5
    case OutcomeCustom = 6
}

/// Entry Object which is saved into the realm database
class Entry: Object {
    @objc dynamic var entryType: Int = EntryType.IncomeSingle.rawValue
    @objc dynamic var amount: Double = 0.0
    @objc dynamic var useText: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var label: String = "UNLABELED"
}

class RecurrentEntry: Object {
    @objc dynamic var days: Int = 0
    @objc dynamic var months: Int = 0
    @objc dynamic var lastDate: Date = Date()
    @objc dynamic var amount: Double = 0.0
    @objc dynamic var use: String = ""
    @objc dynamic var entryType: Int = EntryType.IncomeSingle.rawValue
    @objc dynamic var label: String = "UNLABELED"
    let entries = List<Entry>()
}

@objc enum GoalType: Int {
    case more = 1
    case less = 2
}

class Goal: Object {
    @objc dynamic var goalType: Int = GoalType.more.rawValue
    @objc dynamic var isIncome: Bool = true
    @objc dynamic var amount: Double = 0.0
    @objc dynamic var label: String = ""
    @objc dynamic var startDate: Date = Date()
    @objc dynamic var endDate: Date = Date()
    @objc dynamic var shouldReacurre: Bool = false
    @objc dynamic var isFinished: Bool = false
    @objc dynamic var isSuccess: Bool = false
}

/// Helper class to have a sorted instance the data from the realm database
class SortedEntry {
    let month: Int
    let year: Int
    var entries: [Entry]
    
    init(month: Int, year: Int, entry: Entry) {
        self.month = month
        self.year = year
        self.entries = [entry]
    }
}

/// Helper class - properly structured for chart display
class MonthEntry {
    let month: Int
    let year: Int
    private(set) var amount: Double
    var entries: Int = 0
    
    init(month: Int, year: Int, amount: Double) {
        self.month = month
        self.year = year
        self.amount = amount
    }
    
    func addAmount(amount: Double) {
        self.amount += amount
    }
}

class LabelEntry {
    let label: String
    private(set) var amount: Double
    
    init(label: String, amount: Double) {
        self.label = label
        self.amount = amount
    }
    
    func addAmount(amount: Double) {
        self.amount += amount
    }
    
    func divide(amount: Double) {
        self.amount = (100 / amount) * self.amount
    }
    
    func getAmount() -> Double {
        return self.amount
    }
    
}
