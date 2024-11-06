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
        XCTAssertTrue(closeCountersButton.waitForExistence(timeout: 5))
        closeCountersButton.tap()
    }

    @MainActor
    private func deleteCounter(with app: XCUIApplication) {
        /// Swipe to delete todays counter
        let todayText = app.collectionViews.staticTexts["Today"]
        XCTAssertTrue(todayText.waitForExistence(timeout: 5))
        todayText.swipeLeft()
        /// Delete counter
        let deleteButton = app.buttons["DeleteButton"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 5))
        deleteButton.tap()
        /// Confirm delete
        let deleteConfirmationDialogButton = app.buttons["DeleteConfirmationDialogButton"]
        XCTAssertTrue(deleteConfirmationDialogButton.waitForExistence(timeout: 5))
        deleteConfirmationDialogButton.tap()
    }

    @MainActor
    private func openCountersView(with app: XCUIApplication) {
        /// Open counters view
        let countersButton = app.buttons["CountersButton"]
        XCTAssertTrue(countersButton.waitForExistence(timeout: 5))
        countersButton.tap()
    }

    @MainActor
    private func resetApp(with app: XCUIApplication) {
        /// Open reset confirmation dialog
        let resetButton = app.buttons["ResetButton"]
        XCTAssertTrue(resetButton.waitForExistence(timeout: 5))
        resetButton.tap()
        /// Confirm reset
        let resetConfirmationDialogButton = app.buttons["ResetConfirmationDialogButton"]
        XCTAssertTrue(resetConfirmationDialogButton.waitForExistence(timeout: 5))
        resetConfirmationDialogButton.tap()
        /// Compare counts
        let count = app.getCount(with: app)
        XCTAssertEqual(count, .zero)
    }
}
