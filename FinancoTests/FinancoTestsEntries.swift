//
//  FinancoTestsEntries.swift
//  FinancoTests
//
//  Created by Valentin Witzeneder on 12.06.20.
//  Copyright © 2020 Valentin Witzeneder. All rights reserved.
//

import XCTest
@testable import Financo

class FinancoTestsEntries: XCTestCase {

    func testRawEntriesToSortedEntries() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        //GIVEN
        var dates:[Date] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        if let date1 = formatter.date(from: "2020/01/01") {dates.append(date1)}
        if let date2 = formatter.date(from: "2020/02/01") {dates.append(date2)}
        if let date3 = formatter.date(from: "2020/03/01") {dates.append(date3)}
        if let date4 = formatter.date(from: "2020/04/01") {dates.append(date4)}
        if let date5 = formatter.date(from: "2020/05/01") {dates.append(date5)}
        if let date6 = formatter.date(from: "2020/06/01") {dates.append(date6)}
        if let date7 = formatter.date(from: "2020/07/01") {dates.append(date7)}
        if let date8 = formatter.date(from: "2020/08/01") {dates.append(date8)}
        if let date9 = formatter.date(from: "2020/09/01") {dates.append(date9)}
        if let date10 = formatter.date(from: "2020/10/01") {dates.append(date10)}
        if let date11 = formatter.date(from: "2020/11/01") {dates.append(date11)}
        if let date12 = formatter.date(from: "2020/12/01") {dates.append(date12)}
        
        var entries:[Entry] = []
        
        for i in 0..<dates.count {
            let newEntry = Entry()
            newEntry.amount = Double(i+1)
            newEntry.date = dates[i]
            newEntry.entryType = 1
            newEntry.useText = "TestText"
            newEntry.label = "TestEntry"
            entries.append(newEntry)
        }
        
        //WHEN
        let sortedEntries = realmManager.exposeGetSortedEntriesFromRawData(rawData: entries)
        
        //THEN
        XCTAssertTrue(sortedEntries.count == 12)

        for i in 0..<sortedEntries.count {
            XCTAssertTrue(sortedEntries[i].entries.count == 1)
            XCTAssertTrue(sortedEntries[i].month == i+1)
            XCTAssertTrue(sortedEntries[i].year == 2020)
        }
    }
}
