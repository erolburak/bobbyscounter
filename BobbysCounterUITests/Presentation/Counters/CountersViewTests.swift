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
        app.buttons["CloseCountersButton"].tap()
    }

    @MainActor
    private func deleteCounter(with app: XCUIApplication) {
        /// Swipe to delete todays counter
        app.buttons["CountersListItem"].swipeLeft()
        /// Delete counter
        app.buttons["DeleteButton"].tap()
        /// Confirm delete
        let deleteConfirmationDialogButton =
            app
            .buttons["DeleteConfirmationDialogButton"]
            .firstMatch
        deleteConfirmationDialogButton.waitForExistence(timeout: 5)
            ? deleteConfirmationDialogButton.tap() : XCTFail()
    }

    @MainActor
    private func showCountersView(with app: XCUIApplication) {
        /// Show counters view
        app.buttons["CountersButton"].tap()
    }

    @MainActor
    private func resetApp(with app: XCUIApplication) {
        /// Show reset confirmation dialog
        app.buttons["ResetButton"].tap()
        /// Confirm reset
        let resetConfirmationDialogButton =
            app
            .buttons["ResetConfirmationDialogButton"]
            .firstMatch
        resetConfirmationDialogButton.waitForExistence(timeout: 5)
            ? resetConfirmationDialogButton.tap() : XCTFail()
        /// Check if `InsertButton` exists
        XCTAssertTrue(app.buttons["InsertButton"].exists)
    }
}
