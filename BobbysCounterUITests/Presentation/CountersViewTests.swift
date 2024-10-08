//
//  CountersViewTests.swift
//  BobbysCounterUITests
//
//  Created by Burak Erol on 28.01.24.
//

import XCTest

@MainActor
final class CountersViewTests: XCTestCase {
    // MARK: - Methods

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /// Test delete and confirm delete steps:
    /// 1) Open settings view
    /// 2) Open counters view
    /// 3) Delete todays counter
    /// 4) Check if `DeleteConfirmationDialogButton` exists
    func testDeleteButton() {
        let app = XCUIApplication().appLaunch()
        let settingsButton = app.buttons["SettingsButton"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
        settingsButton.tap()
        let countersButton = app.buttons["CountersButton"]
        XCTAssertTrue(countersButton.waitForExistence(timeout: 5))
        countersButton.tap()
        let todayText = app.collectionViews.staticTexts["Today"]
        XCTAssertTrue(todayText.waitForExistence(timeout: 5))
        todayText.swipeLeft()
        let deleteButton = app.buttons["DeleteButton"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 5))
        deleteButton.tap()
        let deleteConfirmationDialogButton = app.buttons["DeleteConfirmationDialogButton"]
        XCTAssertTrue(deleteConfirmationDialogButton.waitForExistence(timeout: 5))
    }

    /// Test final delete confirmation steps:
    /// 1) Open settings view
    /// 2) Open counters view
    /// 3) Delete todays counter
    /// 4) Confirm deleting todays counter
    func testDeleteConfirmationButton() {
        let app = XCUIApplication().appLaunch()
        let settingsButton = app.buttons["SettingsButton"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
        settingsButton.tap()
        let countersButton = app.buttons["CountersButton"]
        XCTAssertTrue(countersButton.waitForExistence(timeout: 5))
        countersButton.tap()
        let todayText = app.collectionViews.staticTexts["Today"]
        XCTAssertTrue(todayText.waitForExistence(timeout: 5))
        todayText.swipeLeft()
        let deleteButton = app.buttons["DeleteButton"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 5))
        deleteButton.tap()
        let deleteConfirmationDialogButton = app.buttons["DeleteConfirmationDialogButton"]
        XCTAssertTrue(deleteConfirmationDialogButton.waitForExistence(timeout: 5))
        deleteConfirmationDialogButton.tap()
    }

    /// Test reset and confirm reset steps:
    /// 1) Open settings view
    /// 2) Open counters view
    /// 3) Press reset
    /// 4) Check if `ResetConfirmationDialogButton` exists
    func testResetButton() {
        let app = XCUIApplication().appLaunch()
        let settingsButton = app.buttons["SettingsButton"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
        settingsButton.tap()
        let countersButton = app.buttons["CountersButton"]
        XCTAssertTrue(countersButton.waitForExistence(timeout: 5))
        countersButton.tap()
        let resetButton = app.buttons["ResetButton"]
        XCTAssertTrue(resetButton.waitForExistence(timeout: 5))
        resetButton.tap()
        let resetConfirmationDialogButton = app.buttons["ResetConfirmationDialogButton"]
        XCTAssertTrue(resetConfirmationDialogButton.waitForExistence(timeout: 5))
    }

    /// Test final reset confirmation steps:
    /// 1) Open settings view
    /// 2) Open counters view
    /// 3) Press reset
    /// 4) Confirm reset
    /// 5) Check `CountText` for updated value
    func testResetConfirmationButton() {
        let app = XCUIApplication().appLaunch()
        let settingsButton = app.buttons["SettingsButton"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
        settingsButton.tap()
        let countersButton = app.buttons["CountersButton"]
        XCTAssertTrue(countersButton.waitForExistence(timeout: 5))
        countersButton.tap()
        let resetButton = app.buttons["ResetButton"]
        XCTAssertTrue(resetButton.waitForExistence(timeout: 5))
        resetButton.tap()
        let resetConfirmationDialogButton = app.buttons["ResetConfirmationDialogButton"]
        XCTAssertTrue(resetConfirmationDialogButton.waitForExistence(timeout: 5))
        resetConfirmationDialogButton.tap()
        let countText = app.staticTexts["CountText"]
        XCTAssertTrue(countText.waitForExistence(timeout: 5))
        let countTextAsInt = Int(app.staticTexts["CountText"].label)
        XCTAssertEqual(countTextAsInt, 0)
    }

    /// Test close counters view steps:
    /// 1) Open settings view
    /// 2) Open counters view
    /// 3) Close counters view
    func testCloseCountersButton() {
        let app = XCUIApplication().appLaunch()
        let settingsButton = app.buttons["SettingsButton"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
        settingsButton.tap()
        let countersButton = app.buttons["CountersButton"]
        XCTAssertTrue(countersButton.waitForExistence(timeout: 5))
        countersButton.tap()
        let closeCountersButton = app.buttons["CloseCountersButton"]
        XCTAssertTrue(closeCountersButton.waitForExistence(timeout: 5))
        closeCountersButton.tap()
    }
}
