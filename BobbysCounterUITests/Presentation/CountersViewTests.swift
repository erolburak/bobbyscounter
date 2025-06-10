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
        app.openSettingsView(with: app)
        openCountersView(with: app)
        closeCountersView(with: app)
        openCountersView(with: app)
        deleteCounter(with: app)
        app.openSettingsView(with: app)
        openCountersView(with: app)
        resetApp(with: app)
    }

    @MainActor
    private func closeCountersView(with app: XCUIApplication) {
        /// Close counters view
        let closeCountersButton = app.buttons["CloseCountersButton"]
        XCTAssertTrue(closeCountersButton.waitForExistence(timeout: 1))
        closeCountersButton.tap()
    }

    @MainActor
    private func deleteCounter(with app: XCUIApplication) {
        /// Swipe to delete todays counter
        let todayText = app.collectionViews.staticTexts["Today"]
        XCTAssertTrue(todayText.waitForExistence(timeout: 1))
        todayText.swipeLeft()
        /// Delete counter
        let deleteButton = app.buttons["DeleteButton"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 1))
        deleteButton.tap()
        /// Confirm delete
        let deleteConfirmationDialogButton = app.buttons["DeleteConfirmationDialogButton"].firstMatch
        XCTAssertTrue(deleteConfirmationDialogButton.waitForExistence(timeout: 1))
        deleteConfirmationDialogButton.tap()
    }

    @MainActor
    private func openCountersView(with app: XCUIApplication) {
        /// Open counters view
        let countersButton = app.buttons["CountersButton"]
        XCTAssertTrue(countersButton.waitForExistence(timeout: 1))
        countersButton.tap()
    }

    @MainActor
    private func resetApp(with app: XCUIApplication) {
        /// Open reset confirmation dialog
        let resetButton = app.buttons["ResetButton"]
        XCTAssertTrue(resetButton.waitForExistence(timeout: 1))
        resetButton.tap()
        /// Confirm reset
        let resetConfirmationDialogButton = app.buttons["ResetConfirmationDialogButton"].firstMatch
        XCTAssertTrue(resetConfirmationDialogButton.waitForExistence(timeout: 1))
        resetConfirmationDialogButton.tap()
        /// Check if `InsertButton` exists
        let insertButton = app.buttons["InsertButton"]
        XCTAssertTrue(insertButton.waitForExistence(timeout: 1))
    }
}
