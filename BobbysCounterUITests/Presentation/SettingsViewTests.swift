//
//  SettingsViewTests.swift
//  BobbysCounterUITests
//
//  Created by Burak Erol on 24.07.23.
//

import XCTest

@MainActor
final class SettingsViewTests: XCTestCase {
    // MARK: - Methods

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /// Test close settings view steps:
    /// 1) Open settings view
    /// 2) Close settings view
    func testCloseSettingsButton() {
        let app = XCUIApplication().appLaunch()
        let settingsButton = app.buttons["SettingsButton"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
        settingsButton.tap()
        let closeSettingsButton = app.buttons["CloseSettingsButton"]
        XCTAssertTrue(closeSettingsButton.waitForExistence(timeout: 5))
        closeSettingsButton.tap()
    }

    /// Test set selected date to today steps:
    /// 1) Open settings view
    /// 2) Select first day of previous month
    /// 3) Select today
    /// 4) Check `DateText` for updated value
    func testTodayButton() {
        let app = XCUIApplication().appLaunch()
        let settingsButton = app.buttons["SettingsButton"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
        settingsButton.tap()
        let datePicker = app.datePickers["DatePicker"]
        XCTAssertTrue(datePicker.waitForExistence(timeout: 5))
        datePicker.tap()
        let previousMonthButton = app.buttons["Previous Month"]
        XCTAssertTrue(previousMonthButton.waitForExistence(timeout: 5))
        previousMonthButton.tap()
        let firstDayOfMonthButton = app.staticTexts["1"]
        XCTAssertTrue(previousMonthButton.waitForExistence(timeout: 5))
        firstDayOfMonthButton.tap()
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
        settingsButton.tap()
        let todayButton = app.buttons["TodayButton"]
        XCTAssertTrue(todayButton.waitForExistence(timeout: 5))
        todayButton.tap()
        let dateText = app.staticTexts["DateText"]
        XCTAssertTrue(dateText.waitForExistence(timeout: 5))
        XCTAssertEqual(dateText.label, "Today")
    }
}
