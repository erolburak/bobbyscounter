//
//  SettingsViewTests.swift
//  BobbysCounterUITests
//
//  Created by Burak Erol on 24.07.23.
//

import XCTest

final class SettingsViewTests: XCTestCase {
    // MARK: - Methods

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testSettingsView() {
        /// Launch app
        let app = XCUIApplication().appLaunch()
        app.openSettingsView(with: app)
        closeSettingsView(with: app)
        app.openSettingsView(with: app)
        pressChartPointMark(with: app)
        checkTodayButton(with: app)
    }

    @MainActor
    private func checkTodayButton(with app: XCUIApplication) {
        /// Open date picker
        let datePicker = app.datePickers["DatePicker"]
        XCTAssertTrue(datePicker.waitForExistence(timeout: 5))
        datePicker.tap()
        /// Select first day of previous month
        let previousMonthButton = app.buttons["Previous Month"]
        XCTAssertTrue(previousMonthButton.waitForExistence(timeout: 5))
        previousMonthButton.tap()
        let firstDayOfMonthButton = app.staticTexts["1"]
        XCTAssertTrue(previousMonthButton.waitForExistence(timeout: 5))
        firstDayOfMonthButton.tap()
        /// Open settings view
        app.openSettingsView(with: app)
        /// Change selected date to `Today`
        let todayButton = app.buttons["TodayButton"]
        XCTAssertTrue(todayButton.waitForExistence(timeout: 5))
        todayButton.tap()
        /// Check if `DateText` is `Today`
        app.checkDateText(with: app)
    }

    @MainActor
    private func closeSettingsView(with app: XCUIApplication) {
        /// Close settings view
        let closeSettingsButton = app.buttons["CloseSettingsButton"]
        XCTAssertTrue(closeSettingsButton.waitForExistence(timeout: 5))
        closeSettingsButton.tap()
    }

    @MainActor
    private func pressChartPointMark(with app: XCUIApplication) {
        /// Press chart point mark
        let pointMark = app.scrollViews["Chart"].children(matching: .other).element.children(matching: .other).element(boundBy: .zero)
        XCTAssertTrue(pointMark.waitForExistence(timeout: 5))
        pointMark.press(forDuration: 2)
    }
}
