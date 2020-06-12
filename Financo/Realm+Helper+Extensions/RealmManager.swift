//
//  RealmManager.swift
//  Financer
//
//  Created by Valentin Witzeneder on 01.09.18.
//  Copyright © 2018 Valentin Witzeneder. All rights reserved.
//

import Foundation

/// Handles every fetching of Data from Realm + sorting into useable Arrays
class RealmManager {
    
    /// Get all Incomes
    ///
    /// - Returns: An Array of SortedEntries as Incomes
    func getIncomesSorted() -> [SortedEntry] {
        checkAndSaveRecurrentIncomes()
        let entriesQuery: [Entry] = myRealm.objects(Entry.self).filter({ $0.entryType == EntryType.IncomeSingle.rawValue ||
            $0.entryType == EntryType.IncomeMonthly.rawValue ||
            $0.entryType == EntryType.IncomeCustom.rawValue })
        
        if entriesQuery.count > 0 {
            return getSortedEntriesFromRawData(rawData: entriesQuery)
        }
        
        return []
    }
    
    /// Get all Incomes
    ///
    /// - Returns: An Array of SortedEntry as Incomes
    func getOutcomesSorted() -> [SortedEntry] {
        checkAndSaveRecurrentOutcomes()
        let entriesQuery: [Entry] = myRealm.objects(Entry.self).filter({ $0.entryType == EntryType.OutcomeSingle.rawValue ||
            $0.entryType == EntryType.OutcomeMonthly.rawValue ||
            $0.entryType == EntryType.OutcomeCustom.rawValue })
        
        if entriesQuery.count > 0 {
            return getSortedEntriesFromRawData(rawData: entriesQuery)
        }
        
        return []
    }
    
    func getRecurrentEntries(isIncome: Bool) -> [RecurrentEntry] {
        if isIncome {
            return getRecurrentIncomes()
        }
        return getRecurrentOutcomes()
    }
    
    /// Get all recurrent Incomes
    ///
    /// - Returns: Array of Recurrent Incomes
    private func getRecurrentIncomes() -> [RecurrentEntry] {
        let entriesQuery: [RecurrentEntry] = myRealm.objects(RecurrentEntry.self).filter({ $0.entryType == EntryType.IncomeSingle.rawValue ||
            $0.entryType == EntryType.IncomeMonthly.rawValue ||
            $0.entryType == EntryType.IncomeCustom.rawValue })
        
        if entriesQuery.count > 0 {
            return entriesQuery
        }
        return []
    }
    
    /// Get all recurrent Outcomes
    ///
    /// - Returns: Array of Recurrent Outcomes
    private func getRecurrentOutcomes() -> [RecurrentEntry] {
        let entriesQuery: [RecurrentEntry] = myRealm.objects(RecurrentEntry.self).filter({ $0.entryType == EntryType.OutcomeSingle.rawValue ||
            $0.entryType == EntryType.OutcomeMonthly.rawValue ||
            $0.entryType == EntryType.OutcomeCustom.rawValue })
        
        if entriesQuery.count > 0 {
            return entriesQuery
        }
        return []
    }
    
    /// Calculate the monthly Income or Outcome
    ///
    /// - Parameter sortedEntries: Array of SortedEntry as Income or Outcome
    /// - Returns: Array of MonthEntry where all SortedEntry Incomes or Outcomes from the same Month/Year are calculated together
    func getIncOutMonthly(sortedEntries: [SortedEntry]) -> [MonthEntry] {
        var monthlyEntry: [MonthEntry] = []
        
        for entryArr in sortedEntries {
            var numberOfEntries = 0
            let newEntry = MonthEntry(month: entryArr.month, year: entryArr.year, amount: 0)
            for entry in entryArr.entries {
                numberOfEntries += 1
                newEntry.addAmount(amount: entry.amount)
            }
            newEntry.entries = numberOfEntries
            monthlyEntry.append(newEntry)
        }
        
        return monthlyEntry
    }
    
    func getLabelSorted(sortedEntries: [SortedEntry], month: Int, year: Int) -> [LabelEntry] {
        var labelEntries: [LabelEntry] = []
        for sortedEntry in sortedEntries {
            if sortedEntry.month == month && sortedEntry.year == year {
                outerloop: for entry in sortedEntry.entries {
                    for labelEntry in labelEntries {
                        if entry.label == labelEntry.label {
                            labelEntry.addAmount(amount: entry.amount)
                            continue outerloop
                        }
                    }
                    labelEntries.append(LabelEntry(label: entry.label, amount: entry.amount))
                }
            }
        }
        return labelEntries
    }
    
    
    /// Calculate the Balance
    ///
    /// - Returns: Array of SortedEntry as Balance
    func getBalanceSorted() -> [SortedEntry] {
        var balance: [SortedEntry] = []
        let entriesQuery: [Entry] = Array(myRealm.objects(Entry.self))
        balance = getSortedEntriesFromRawData(rawData: entriesQuery)
        return balance
    }
    
    /// Calculate the monthly Balance
    ///
    /// - Parameter sortedEntries: Array of SortedEntry as Balance
    /// - Returns: Array of MonthEntry where all SortedEntry Balance from the same Month/Year are calculated together
    func getBalanceMonthly(sortedEntries: [SortedEntry]) -> [MonthEntry] {
        var monthlyEntry: [MonthEntry] = []
        
        for entryArr in sortedEntries {
            let newEntry = MonthEntry(month: entryArr.month, year: entryArr.year, amount: 0)
            for entry in entryArr.entries {
                if entry.entryType == EntryType.OutcomeCustom.rawValue || entry.entryType == EntryType.OutcomeSingle.rawValue || entry.entryType == EntryType.OutcomeMonthly.rawValue {
                    newEntry.addAmount(amount: entry.amount * -1)
                } else {
                    newEntry.addAmount(amount: entry.amount)
                }
            }
            monthlyEntry.append(newEntry)
        }
        return monthlyEntry
    }
    
    /// Sort an Array of Entry into an Array of SortedEntry
    ///
    /// - Parameter rawData: the unsorted Array of Entry
    /// - Returns: the sorted Array of SortedEntry
    private func getSortedEntriesFromRawData(rawData: [Entry]) -> [SortedEntry] {
        
        var sortedEntries: [SortedEntry] = []
        let calendar = Calendar.current
        
        realmData: for entry in rawData {
            let dateComponents = calendar.dateComponents([.day, .month, .year], from: entry.date)
            
            guard let month = dateComponents.month, let year = dateComponents.year else {
                NSLog("Failure in getting the date components from the date")
                return []
            }
            
            // Check first time entry
            if sortedEntries.count < 1 {
                sortedEntries.append(SortedEntry(month: month, year: year, entry: entry))
            } else {
                // Check if entry with same Month/Year is already there
                for sortedEntry in sortedEntries {
                    if sortedEntry.month == month && sortedEntry.year == year {
                        // There is already a SortedEntry with this Month/Year
                        sortedEntry.entries.append(entry)
                        sortedEntry.entries.sort(by: {$0.date < $1.date})
                        continue realmData
                    }
                }
                // There is no SortedEntry with this Month/Year
                sortedEntries.append(SortedEntry(month: month, year: year, entry: entry))
            }
        }
        if sortedEntries.count > 1 {
            // Now sort the sortedEntries by date (Month/Year)
            sortedEntries.sort(by: { $0.year == $1.year ? $0.month < $1.month : $0.year < $1.year })
        }
        // Finally return the sorted Entries
        return sortedEntries
    }
    
    /// Used only in the AppDelegate when app is started to check all recurrent entries for updating
    func checkAndSaveRecurrentEntries() {
        checkAndSaveRecurrentOutcomes()
        checkAndSaveRecurrentIncomes()
    }
    
    /// Check all recurrent Incomes and save them to the Entry Objects in the realm Database if needed
    func checkAndSaveRecurrentIncomes() {
        let entriesQuery: [RecurrentEntry] = myRealm.objects(RecurrentEntry.self).filter({
            $0.entryType == EntryType.IncomeMonthly.rawValue ||
            $0.entryType == EntryType.IncomeCustom.rawValue })
        
        checkAndSaveRecurrent(query: entriesQuery)
    }
    
    /// Check all recurrent Outcomes and save them to the Entry Objects in the realm Database if needed
    func checkAndSaveRecurrentOutcomes() {
        let entriesQuery: [RecurrentEntry] = myRealm.objects(RecurrentEntry.self).filter({
            $0.entryType == EntryType.OutcomeMonthly.rawValue ||
            $0.entryType == EntryType.OutcomeCustom.rawValue })
        
        checkAndSaveRecurrent(query: entriesQuery)
    }
    
    /// Checks the recurrent entries from the RecurrentEntry Objects in the realm Database and save a new Instance in Entry Objects if needed
    ///
    /// - Parameter query: The Incomes or Outcomes Query of the RecurrentEntry Objects in the realm Database
    private func checkAndSaveRecurrent(query: [RecurrentEntry]) {
        
        let date = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date())
        guard let currentDate = date else {
            //TODO: Unable to get current Date
            return
        }
        
        for entry in query {
            var dateComponent = DateComponents()
            dateComponent.day = entry.days
            dateComponent.month = entry.months
            
            guard var newDate = Calendar.current.date(byAdding: dateComponent, to: entry.lastDate) else {
                //Todo: Unable to calculate new Date before while loop
                return
            }
           
            while currentDate >= newDate {
                let newEntry = Entry()
                newEntry.amount = entry.amount
                newEntry.useText = entry.use
                newEntry.entryType = entry.entryType
                newEntry.label = entry.label
                newEntry.date = newDate
                
                try! myRealm.write {
                    myRealm.add(newEntry)
                    entry.entries.append(newEntry)
                    entry.lastDate = newDate
                }
                
                guard let newDateHelper = Calendar.current.date(byAdding: dateComponent, to: newDate) else {
                    //Todo: Unable to calculate new Date in while loop
                    return
                }
                
                newDate = newDateHelper
                
            } // end while
        }
    }
    
    func getMosedFrequentMonthlyLabel(sortedEntries: [SortedEntry], month: Int, year: Int) -> String {
        var title = "-"
        
        var labelDic: [String: Double] = [:]
        
        for sortedEntry in sortedEntries {
            if sortedEntry.year == year && sortedEntry.month == month {
                for entry in sortedEntry.entries {
                    if labelDic[entry.label] != nil {
                        guard let amount = labelDic[entry.label] else { return title }
                        labelDic[entry.label] = amount + entry.amount
                    } else {
                        labelDic[entry.label] = entry.amount
                    }
                }
            }
            break
        }
        
        var largest = 0.0
        for (kind, number) in labelDic {
            if title != "UNLABELED" {
                if number > largest {
                    largest = number
                    title = kind
                }
            }
        }
        return title
    }
    
    private func getIncomeGoals() -> [Goal]{
        var entriesQuery: [Goal] = myRealm.objects(Goal.self).filter({ $0.isIncome == true })
        if entriesQuery.count > 0 {
            entriesQuery = entriesQuery.sorted { $0.startDate < $1.startDate }
            return entriesQuery
        }
        return []
    }
    
    private func getOutcomeGoals() -> [Goal]{
        var entriesQuery: [Goal] = myRealm.objects(Goal.self).filter({ $0.isIncome == false })
        if entriesQuery.count > 0 {
            entriesQuery = entriesQuery.sorted { $0.startDate < $1.startDate }
            return entriesQuery
        }
        return []
    }
    
    func getGoals(isIncome: Bool) -> [Goal] {
        if isIncome {
            return getIncomeGoals()
        }
        return getOutcomeGoals()
    }
    
    func getCurrentGoalEntries(goal: Goal) -> [Entry] {
        var query: [Entry] = []
        
        if goal.isIncome {
            query = myRealm.objects(Entry.self).filter({ ($0.entryType == EntryType.IncomeSingle.rawValue ||
                $0.entryType == EntryType.IncomeMonthly.rawValue ||
                $0.entryType == EntryType.IncomeCustom.rawValue) && $0.date.isBetween(goal.startDate, and: goal.endDate) && $0.label == goal.label})
        } else {
            query = myRealm.objects(Entry.self).filter({ ($0.entryType == EntryType.OutcomeSingle.rawValue ||
                $0.entryType == EntryType.OutcomeMonthly.rawValue ||
                $0.entryType == EntryType.OutcomeCustom.rawValue) && $0.date.isBetween(goal.startDate, and: goal.endDate) && $0.label == goal.label})
        }
        
        if query.count < 1 { return [] }
        
        return query
    }
    
    func checkAllGoals() {
        var goals = getIncomeGoals()
        goals.append(contentsOf: getOutcomeGoals())
        let calendar = Calendar.current
        
        for goal in goals {
            if goal.isFinished {
                continue
            }
            let goalAmount = getCurrentGoalEntries(goal: goal)
            var amount = 0.0
            for entry in goalAmount {
                amount += entry.amount
            }
            let endDate = calendar.startOfDay(for: goal.endDate)
            let currentDate = calendar.startOfDay(for: Date())
            
            
            if goal.goalType == GoalType.less.rawValue {
                
                if endDate <= currentDate {
                    try! myRealm.write {
                        goal.isFinished = true
                    }
                }

                if amount < goal.amount {
                    try! myRealm.write {
                        goal.isSuccess = true
                    }
                    //TODO: SHOW USER SOME ACKNOLEDGMENT!
                } else {
                    try! myRealm.write {
                        goal.isSuccess = false
                    }
                }
                
            } else { // goalType == GoalType.more.rawValue
                
                if endDate <= currentDate {
                    try! myRealm.write {
                        goal.isFinished = true
                    }
                }
                
                if amount >= goal.amount {
                    try! myRealm.write {
                        goal.isSuccess = true
                    }
                    //TODO: SHOW USER SOME ACKNOLEDGMENT!
                } else {
                    try! myRealm.write {
                        goal.isSuccess = false
                    }
                }
            }
        }
    }
}

#if DEBUG
extension RealmManager {
    public func exposeGetSortedEntriesFromRawData(rawData: [Entry]) -> [SortedEntry] {
        return self.getSortedEntriesFromRawData(rawData: rawData)
    }
}
#endif

