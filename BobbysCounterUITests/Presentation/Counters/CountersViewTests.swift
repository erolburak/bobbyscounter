//
//  CountersViewTests.swift
//  BobbysCounterUITests
//
//  Created by Burak Erol on 28.01.24.
//

import XCTest

final class CountersViewTests: XCTestCase {
    // MARK: - Methods

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testCountersView() {
        /// Launch app
        let app = XCUIApplication().appLaunch()
        app.showSettingsView(with: app)
        showCountersView(with: app)
        closeCountersView(with: app)
        showCountersView(with: app)
        deleteCounter(with: app)
        app.showSettingsView(with: app)
        showCountersView(with: app)
        resetApp(with: app)
    }

    @MainActor
    private func closeCountersView(with app: XCUIApplication) {
        /// Close counters view
        app.buttons["CloseCountersButton"].waitForExistence().tap()
    }

    @MainActor
    private func deleteCounter(with app: XCUIApplication) {
        /// Swipe to delete todays counter
        app.buttons["CountersListItem"].waitForExistence().swipeLeft()
        /// Delete counter
        app.buttons["DeleteButton"].waitForExistence().tap()
        /// Confirm delete
        app.buttons["DeleteConfirmationDialogButton"].firstMatch.waitForExistence().tap()
    }

    @MainActor
    private func showCountersView(with app: XCUIApplication) {
        /// Show counters view
        app.buttons["CountersButton"].waitForExistence().tap()
    }

    @MainActor
    private func resetApp(with app: XCUIApplication) {
        /// Show reset confirmation dialog
        app.buttons["ResetButton"].waitForExistence().tap()
        /// Confirm reset
        app.buttons["ResetConfirmationDialogButton"].firstMatch.waitForExistence().tap()
        /// Check if `InsertButton` exists
        app.buttons["InsertButton"].waitForExistence()
    }
}
