//
//  FinancoUITestsNewEntry.swift
//  FinancoUITests
//
//  Created by Valentin Witzeneder on 12.06.20.
//  Copyright © 2020 Valentin Witzeneder. All rights reserved.
//

import XCTest

class FinancoUITestsNewEntry: XCTestCase {

    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    func testNewEntryIncome() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let app = XCUIApplication()
        app.launchArguments = ["-FirstStart", "YES"]
        app.launch()
        app.tabBars.buttons["Manage"].tap()
        
        let incomesNavigationBar = app.navigationBars["Incomes"]
        incomesNavigationBar.buttons["Add"].tap()
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .textField).element.tap()
        let key = app/*@START_MENU_TOKEN@*/.keys["1"]/*[[".keyboards.keys[\"1\"]",".keys[\"1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key.tap()
        key.tap()
        element.children(matching: .textView).element.tap()
        let qKey = app.keys["T"]
        qKey.tap()
        incomesNavigationBar.buttons["Done"].tap()
    }
    
    func testNewEntryMistrial() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let app = XCUIApplication()
        app.launchArguments = ["-FirstStart", "YES"]
        app.launch()
        app.tabBars.buttons["Manage"].tap()
        
        let incomesNavigationBar = app.navigationBars["Incomes"]
        incomesNavigationBar.buttons["Add"].tap()
        incomesNavigationBar.buttons["Done"].tap()
        app.alerts["Mistrial"].buttons["OK"].tap()
    }
    
}
