//
//  FinancoTestsRealm.swift
//  FinancoTests
//
//  Created by Valentin Witzeneder on 12.06.20.
//  Copyright © 2020 Valentin Witzeneder. All rights reserved.
//

import XCTest
@testable import Financo

class FinancoTestsRealm: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try! myRealm.write {
            myRealm.deleteAll()
         }
    }

    func testSimpleObject() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let newEntry = Entry()
        newEntry.amount = 1
        let date = Date.init()
        newEntry.date = date
        newEntry.entryType = 1
        newEntry.useText = "testText"
        newEntry.label = "TestEntry"
        
        XCTAssertTrue(newEntry.label == "TestEntry")
        XCTAssertTrue(newEntry.useText == "testText")
        XCTAssertTrue(newEntry.entryType == 1)
        XCTAssertTrue(newEntry.date == date)
        XCTAssertTrue(newEntry.amount == 1)
    }
    
    func testRealmOnSameObject() {
        //GIVEN
        let newEntry = Entry()
        newEntry.amount = 1
        let date = Date.init()
        newEntry.date = date
        newEntry.entryType = 1
        newEntry.useText = "testText"
        newEntry.label = "TestEntry"
        
        //WHEN
        try! myRealm.write {
            for _ in 0..<20 {
                myRealm.add(newEntry)
            }
        }
        let entries = realmManager.getIncomesSorted()
        
        //THEN
        //Size should only be 1 because its the same month/year
        XCTAssertTrue(entries.count == 1)
        
        //Size should only be 1 because realm recognizes that it is the same object every time
        XCTAssertTrue(entries[0].entries.count == 1)
    }
    
    func testRealmOnDifferentObject() {
        
        //GIVEN
        var myEntries: [Entry] = []
        for _ in 0..<20 {
            let newEntry = Entry()
            newEntry.amount = 1
            let date = Date.init()
            newEntry.date = date
            newEntry.entryType = 1
            newEntry.useText = "testText"
            newEntry.label = "TestEntry"
            myEntries.append(newEntry)
        }
        
        //WHEN
        try! myRealm.write {
            for i in 0..<myEntries.count {
                myRealm.add(myEntries[i])
            }
        }
        let entries = realmManager.getIncomesSorted()
        
        //THEN
        //Size should only be 1 because its the same month/year
        XCTAssertTrue(entries.count == 1)
        
        //Size should only be 20 because entries are different objects
        XCTAssertTrue(entries[0].entries.count == 20)
    }
    
    func testRealmOnDifferentObjectIncomeSpecific() {
        
        //GIVEN
        var myEntries: [Entry] = []
        for i in 1..<31 {
            let newEntry = Entry()
            newEntry.amount = 1
            let date = Date.init()
            newEntry.date = date
            //Split up over our 6 types of entries
            newEntry.entryType = i%6+1
            newEntry.useText = "testText"
            newEntry.label = "TestEntry"
            myEntries.append(newEntry)
        }
        
        //WHEN
        try! myRealm.write {
            for i in 0..<myEntries.count {
                myRealm.add(myEntries[i])
            }
        }
        let entries = realmManager.getIncomesSorted()
        
        //THEN
        //Size should only be 1 because its the same month/year
        XCTAssertTrue(entries.count == 1)
        
        //Size should only be 15 because half of the entries we saved are incomes and half are outcomes
        XCTAssertTrue(entries[0].entries.count == 15)
    }
    
    func testRealmOnDifferentObjectOutcomeSpecific() {
        
        //GIVEN
        var myEntries: [Entry] = []
        for i in 1..<31 {
            let newEntry = Entry()
            newEntry.amount = 1
            let date = Date.init()
            newEntry.date = date
            //Split up over our 6 types of entries
            newEntry.entryType = i%6+1
            newEntry.useText = "testText"
            newEntry.label = "TestEntry"
            myEntries.append(newEntry)
        }
        
        //WHEN
        try! myRealm.write {
            for i in 0..<myEntries.count {
                myRealm.add(myEntries[i])
                print(myEntries[i].entryType)
            }
        }
        let entries = realmManager.getOutcomesSorted()
        
        //THEN
        //Size should only be 1 because its the same month/year
        XCTAssertTrue(entries.count == 1)
        
        //Size should only be 15 because half of the entries we saved are incomes and half are outcomes
        XCTAssertTrue(entries[0].entries.count == 15)
    }
}
