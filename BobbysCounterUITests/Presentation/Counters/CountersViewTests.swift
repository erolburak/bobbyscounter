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
        showCountersView(with: app)
        deleteCounters(with: app)
        app.addNewCounter(with: app)
        showCountersView(with: app)
        deleteCounter(with: app)
        closeCountersView(with: app)
    }

    @MainActor
    private func closeCountersView(with app: XCUIApplication) {
        /// Close counters view
        app.buttons[Accessibility.closeCountersButton.id].waitForExistence().tap()
    }

    @MainActor
    private func deleteCounter(with app: XCUIApplication) {
        /// Swipe to delete counter
        app.buttons[Accessibility.countersListItem.id].waitForExistence().swipeLeft()
        /// Delete counter
        app.buttons[Accessibility.deleteCounterButtonSwipeAction.id].waitForExistence().tap()
        /// Confirm delete
        app.buttons[Accessibility.deleteCounterButtonConfirmationDialog.id].firstMatch
            .waitForExistence().tap()
    }

    @MainActor
    private func deleteCounters(with app: XCUIApplication) {
        /// Show delete counters
        app.buttons[Accessibility.deleteCountersButton.id].waitForExistence().tap()
        /// Confirm delete
        app.buttons[Accessibility.deleteCountersButtonConfirmationDialog.id].firstMatch
            .waitForExistence().tap()
        /// Check if `AddCounterButton` exists
        app.buttons[Accessibility.addCounterButton.id].waitForExistence()
    }

    @MainActor
    private func showCountersView(with app: XCUIApplication) {
        /// Show settings menu
        app.showSettingsMenu(with: app)
        /// Show counters view
        app.buttons[Accessibility.countersButton.id].waitForExistence().tap()
    }
}
