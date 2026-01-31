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
        changeDate(with: app)
        changeDateToToday(with: app)
        app.showSettingsView(with: app)
        toggleDecrementNegative(with: app)
        changeStep(with: app)
        pressChartPointMark(with: app)
        resetApp(with: app)
        closeSettingsView(with: app)
    }

    @MainActor
    private func changeDate(with app: XCUIApplication) {
        /// Show settings view
        app.showSettingsView(with: app)
        /// Show date picker
        app.datePickers[Accessibility.datePicker.id].waitForExistence().tap()
        /// Select first day of previous month
        app.buttons["Previous Month"].waitForExistence().tap()
        app.staticTexts["1"].firstMatch.waitForExistence().tap()
    }

    @MainActor
    private func changeDateToToday(with app: XCUIApplication) {
        /// Show settings view
        app.showSettingsView(with: app)
        /// Change selected date to `Today`
        app.buttons[Accessibility.todayButton.id].waitForExistence().tap()
    }

    @MainActor
    private func changeStep(with app: XCUIApplication) {
        /// Show steps picker
        app.buttons[Accessibility.stepsPicker.id].waitForExistence().tap()
        /// Change step to `10`
        app.buttons["10"].waitForExistence().tap()
    }

    @MainActor
    private func closeSettingsView(with app: XCUIApplication) {
        /// Show settings view
        app.showSettingsView(with: app)
        /// Close settings view
        app.buttons[Accessibility.closeSettingsButton.id].waitForExistence().tap()
    }

    @MainActor
    private func pressChartPointMark(with app: XCUIApplication) {
        /// Press chart point mark
        app.scrollViews[Accessibility.chart.id]
            .children(matching: .other)
            .element
            .children(matching: .other)
            .element(boundBy: .zero)
            .press(forDuration: 1)
    }

    @MainActor
    private func resetApp(with app: XCUIApplication) {
        /// Show settings menu
        app.buttons[Accessibility.settingsMenu.id].waitForExistence().tap()
        /// Show reset confirmation dialog
        app.buttons[Accessibility.resetButton.id].waitForExistence().tap()
        /// Confirm reset
        app.buttons[Accessibility.resetButtonConfirmationDialog.id].firstMatch.waitForExistence()
            .tap()
        /// Check if `ShowCategoryAddButton` exists
        app.buttons[Accessibility.showCategoryAddButton.id].waitForExistence()
    }

    @MainActor
    private func toggleDecrementNegative(with app: XCUIApplication) {
        /// Toggle decrement negative
        app.switches[Accessibility.decrementNegativeToggle.id].waitForExistence().tap()
    }
}
