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
        app.showSettingsView(with: app)
        closeSettingsView(with: app)
        app.showSettingsView(with: app)
        pressChartPointMark(with: app)
        checkTodayButton(with: app)
    }

    @MainActor
    private func checkTodayButton(with app: XCUIApplication) {
        /// Show date picker
        app.datePickers["DatePicker"].tap()
        /// Select first day of previous month
        app.buttons["Previous Month"].tap()
        app.staticTexts["1"].tap()
        /// Show settings view
        app.showSettingsView(with: app)
        /// Change selected date to `Today`
        app.buttons["TodayButton"].tap()
        /// Check if `DateText` is `Today`
        app.checkDateText(with: app)
    }

    @MainActor
    private func closeSettingsView(with app: XCUIApplication) {
        /// Close settings view
        app.buttons["CloseSettingsButton"].tap()
    }

    @MainActor
    private func pressChartPointMark(with app: XCUIApplication) {
        /// Press chart point mark
        app.scrollViews["Chart"].children(matching: .other).element.children(matching: .other).element(boundBy: .zero).press(forDuration: 1)
    }
}
