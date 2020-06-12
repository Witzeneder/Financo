//
//  FinancoUITestsTabs.swift
//  FinancoUITests
//
//  Created by Valentin Witzeneder on 12.06.20.
//  Copyright © 2020 Valentin Witzeneder. All rights reserved.
//

import XCTest

class FinancoUITestsTabs: XCTestCase {
    
    func testAppStartFirstTab() {
        let app = XCUIApplication()
        app.launchArguments = ["-FirstStart", "YES"]
        app.launch()
        app.tabBars.buttons.element(boundBy: 0).tap()
    }

    func testAppStartSecondTab() {
        let app = XCUIApplication()
        app.launchArguments = ["-FirstStart", "YES"]
        app.launch()
        app.tabBars.buttons.element(boundBy: 1).tap()
    }
    
    func testAppStartThirdTab() {
        let app = XCUIApplication()
        app.launchArguments = ["-FirstStart", "YES"]
        app.launch()
        app.tabBars.buttons.element(boundBy: 2).tap()
    }
    
    func testAppStartFourthTab() {
        let app = XCUIApplication()
        app.launchArguments = ["-FirstStart", "YES"]
        app.launch()
        app.tabBars.buttons.element(boundBy: 3).tap()
    }
    
    func testAppStartFifthTab() {
        let app = XCUIApplication()
        app.launchArguments = ["-FirstStart", "YES"]
        app.launch()
        app.tabBars.buttons.element(boundBy: 4).tap()
    }
    
    func testAppStartAllTabs() {
        let app = XCUIApplication()
        app.launchArguments = ["-FirstStart", "YES"]
        app.launch()
        app.tabBars.buttons.element(boundBy: 0).tap()
        app.tabBars.buttons.element(boundBy: 1).tap()
        app.tabBars.buttons.element(boundBy: 2).tap()
        app.tabBars.buttons.element(boundBy: 3).tap()
        app.tabBars.buttons.element(boundBy: 4).tap()
    }
    
}
