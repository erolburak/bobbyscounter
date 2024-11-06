//
//  ContentViewTests.swift
//  BobbysCounterUITests
//
//  Created by Burak Erol on 24.07.23.
//

import XCTest

final class ContentViewTests: XCTestCase {
    // MARK: - Methods

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testContentView() {
        /// Launch app
        let app = XCUIApplication().appLaunch()
        app.checkDateText(with: app)
        checkSettingsButton(with: app)
        increaseCount(with: app)
        decreaseCount(with: app)
    }

    @MainActor
    private func checkSettingsButton(with app: XCUIApplication) {
        /// Check if `SettingsButton` is enabled
        let settingsButton = app.buttons["SettingsButton"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
        XCTAssertTrue(settingsButton.isEnabled)
    }

    @MainActor
    private func decreaseCount(with app: XCUIApplication) {
        /// Get count
        let count = app.getCount(with: app)
        /// Decrease count
        let minusButton = app.buttons["MinusButton"]
        XCTAssertTrue(minusButton.waitForExistence(timeout: 5))
        minusButton.tap()
        /// Compare counts
        let newCount = app.getCount(with: app)
        XCTAssertEqual(count - 1, newCount)
    }

    @MainActor
    private func increaseCount(with app: XCUIApplication) {
        /// Get count
        let count = app.getCount(with: app)
        /// Increase count
        let plusButton = app.buttons["PlusButton"]
        XCTAssertTrue(plusButton.waitForExistence(timeout: 5))
        plusButton.tap()
        /// Compare counts
        let newCount = app.getCount(with: app)
        XCTAssertEqual(count + 1, newCount)
    }
}
