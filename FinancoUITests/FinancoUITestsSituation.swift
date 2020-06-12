//
//  FinancoUITestsSituation.swift
//  FinancoUITests
//
//  Created by Valentin Witzeneder on 12.06.20.
//  Copyright © 2020 Valentin Witzeneder. All rights reserved.
//

import XCTest

class FinancoUITestsSituation: XCTestCase {

    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    func testMonthDatePicker() {
        let app = XCUIApplication()
        app.launchArguments = ["-FirstStart", "YES"]
        app.launchArguments += ["testMode"]
        app.launch()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Januar")
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Februar")
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "March")
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "April")
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "May")
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "June")
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "July")
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "August")
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "September")
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "October")
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "November")
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "December")
    }
    
    func testYearDatePicker() {
        let app = XCUIApplication()
        app.launchArguments = ["-FirstStart", "YES"]
        app.launchArguments += ["testMode"]
        app.launch()
        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "2018")
        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "2019")
        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "2020")
        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "2021")
        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "2022")
    }

}
