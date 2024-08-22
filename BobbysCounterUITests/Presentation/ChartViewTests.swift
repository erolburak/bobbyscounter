//
//  ChartViewTests.swift
//  BobbysCounterUITests
//
//  Created by Burak Erol on 28.01.24.
//

import XCTest

@MainActor
final class ChartViewTests: XCTestCase {
    // MARK: - Methods

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /// Test if `Chart` exists steps:
    /// 1) Close settings tip
    /// 2) Increase counter count value for current day
    /// 3) Increase counter count value for first day of previous month
    /// 4) Open settings view
    /// 5) Check if `Chart` exists
    func testChart() {
        let app = XCUIApplication()
        app.launch()
        app.closeSettingsTip()
        let plusButton = app.buttons["PlusButton"]
        XCTAssertTrue(plusButton.waitForExistence(timeout: 5))
        plusButton.tap()
        let settingsButton = app.buttons["SettingsButton"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
        settingsButton.tap()
        let datePicker = app.datePickers["DatePicker"]
        XCTAssertTrue(datePicker.waitForExistence(timeout: 5))
        datePicker.tap()
        let previousMonthButton = app.buttons["Previous Month"]
        XCTAssertTrue(previousMonthButton.waitForExistence(timeout: 5))
        previousMonthButton.tap()
        let firstDayOfMonthButton = app.datePickers.collectionViews.staticTexts["1"]
        XCTAssertTrue(previousMonthButton.waitForExistence(timeout: 5))
        firstDayOfMonthButton.tap()
        XCTAssertTrue(plusButton.waitForExistence(timeout: 5))
        plusButton.tap()
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
        settingsButton.tap()
        let chart = app.scrollViews["Chart"]
        XCTAssertTrue(chart.waitForExistence(timeout: 5))
        let pointMark = app.scrollViews["Chart"].children(matching: .other).element.children(matching: .other).element(boundBy: 0)
        XCTAssertTrue(pointMark.waitForExistence(timeout: 5))
        pointMark.press(forDuration: 2)
    }
}
