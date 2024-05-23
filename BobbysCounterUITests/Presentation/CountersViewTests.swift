//
//  CountersViewTests.swift
//  BobbysCounterUITests
//
//  Created by Burak Erol on 28.01.24.
//

import XCTest

final class CountersViewTests: XCTestCase {

	// MARK: - Actions

	override func setUpWithError() throws {
		continueAfterFailure = false
	}

	/// Test delete and confirm delete steps:
	/// 1) Close settings tip
	/// 2) Open settings view
	/// 3) Open counters view
	/// 4) Delete todays counter
	/// 5) Check if `DeleteConfirmationDialogButton` exists
	@MainActor
	func testDeleteButton() {
		let app = XCUIApplication()
		app.launch()
		app.closeSettingsTip()
		let settingsButton = app.buttons["SettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
		settingsButton.tap()
		let countersButton = app.navigationBars["Settings"].buttons["CountersButton"]
		XCTAssertTrue(countersButton.waitForExistence(timeout: 5))
		countersButton.tap()
		let todayText = app.collectionViews.staticTexts["Today"]
		XCTAssertTrue(todayText.waitForExistence(timeout: 5))
		todayText.swipeLeft()
		let deleteButton = app.collectionViews.buttons["DeleteButton"]
		XCTAssertTrue(deleteButton.waitForExistence(timeout: 5))
		deleteButton.tap()
		let deleteConfirmationDialogButton = app.scrollViews.otherElements.buttons["DeleteConfirmationDialogButton"]
		XCTAssertTrue(deleteConfirmationDialogButton.waitForExistence(timeout: 5))
	}

	/// Test final delete confirmation steps:
	/// 1) Close settings tip
	/// 2) Open settings view
	/// 3) Open counters view
	/// 4) Delete todays counter
	/// 5) Confirm deleting todays counter
	@MainActor
	func testDeleteConfirmationButton() {
		let app = XCUIApplication()
		app.launch()
		app.closeSettingsTip()
		let settingsButton = app.buttons["SettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
		settingsButton.tap()
		let countersButton = app.navigationBars["Settings"].buttons["CountersButton"]
		XCTAssertTrue(countersButton.waitForExistence(timeout: 5))
		countersButton.tap()
		let todayText = app.collectionViews.staticTexts["Today"]
		XCTAssertTrue(todayText.waitForExistence(timeout: 5))
		todayText.swipeLeft()
		let deleteButton = app.collectionViews.buttons["DeleteButton"]
		XCTAssertTrue(deleteButton.waitForExistence(timeout: 5))
		deleteButton.tap()
		let deleteConfirmationDialogButton = app.scrollViews.otherElements.buttons["DeleteConfirmationDialogButton"]
		XCTAssertTrue(deleteConfirmationDialogButton.waitForExistence(timeout: 5))
		deleteConfirmationDialogButton.tap()
	}

	/// Test reset and confirm reset steps:
	/// 1) Close settings tip
	/// 2) Open settings view
	/// 3) Open counters view
	/// 4) Press reset
	/// 5) Check if `ResetConfirmationDialogButton` exists
	@MainActor
	func testResetButton() {
		let app = XCUIApplication()
		app.launch()
		app.closeSettingsTip()
		let settingsButton = app.buttons["SettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
		settingsButton.tap()
		let countersButton = app.navigationBars["Settings"].buttons["CountersButton"]
		XCTAssertTrue(countersButton.waitForExistence(timeout: 5))
		countersButton.tap()
		let resetButton = app.navigationBars["Counters"].buttons["ResetButton"]
		XCTAssertTrue(resetButton.waitForExistence(timeout: 5))
		resetButton.tap()
		let resetConfirmationDialogButton = app.scrollViews.otherElements.buttons["ResetConfirmationDialogButton"]
		XCTAssertTrue(resetConfirmationDialogButton.waitForExistence(timeout: 5))
	}

	/// Test final reset confirmation steps:
	/// 1) Close settings tip
	/// 2) Open settings view
	/// 3) Open counters view
	/// 4) Press reset
	/// 5) Confirm reset
	/// 6) Check `CountText` for updated value
	@MainActor
	func testResetConfirmationButton() {
		let app = XCUIApplication()
		app.launch()
		app.closeSettingsTip()
		let settingsButton = app.buttons["SettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
		settingsButton.tap()
		let countersButton = app.navigationBars["Settings"].buttons["CountersButton"]
		XCTAssertTrue(countersButton.waitForExistence(timeout: 5))
		countersButton.tap()
		let resetButton = app.navigationBars["Counters"].buttons["ResetButton"]
		XCTAssertTrue(resetButton.waitForExistence(timeout: 5))
		resetButton.tap()
		let resetConfirmationDialogButton = app.scrollViews.otherElements.buttons["ResetConfirmationDialogButton"]
		XCTAssertTrue(resetConfirmationDialogButton.waitForExistence(timeout: 5))
		resetConfirmationDialogButton.tap()
		let countText = app.staticTexts["CountText"]
		XCTAssertTrue(countText.waitForExistence(timeout: 5))
		let countTextAsInt = Int(app.staticTexts["CountText"].label)
		XCTAssertEqual(countTextAsInt, 0)
	}

	/// Test close counters view steps:
	/// 1) Close settings tip
	/// 2) Open settings view
	/// 3) Open counters view
	/// 4) Close counters view
	@MainActor
	func testCloseCountersButton() {
		let app = XCUIApplication()
		app.launch()
		app.closeSettingsTip()
		let settingsButton = app.buttons["SettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
		settingsButton.tap()
		let countersButton = app.navigationBars["Settings"].buttons["CountersButton"]
		XCTAssertTrue(countersButton.waitForExistence(timeout: 5))
		countersButton.tap()
		let closeCountersButton = app.navigationBars["Counters"].buttons["CloseCountersButton"]
		XCTAssertTrue(closeCountersButton.waitForExistence(timeout: 5))
		closeCountersButton.tap()
	}
}
