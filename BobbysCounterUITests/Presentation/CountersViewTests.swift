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

	/// Test delete and confirm delete while first opening settings and then counters view
	func testDeleteButton() {
		let app = XCUIApplication()
		app.launch()
		let settingsButton = app.buttons["SettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
		settingsButton.tap()
		let countersButton = app.navigationBars[Locale.current.language.languageCode == "en" ? "Settings" : ""].buttons["CountersButton"]
		XCTAssertTrue(countersButton.waitForExistence(timeout: 5))
		countersButton.tap()
		let todayText = app.collectionViews.staticTexts[Locale.current.language.languageCode == "en" ? "Today" : ""]
		XCTAssertTrue(todayText.waitForExistence(timeout: 5))
		todayText.swipeLeft()
		let deleteButton = app.collectionViews.buttons["DeleteButton"]
		XCTAssertTrue(deleteButton.waitForExistence(timeout: 5))
		deleteButton.tap()
		let deleteConfirmationDialogButton = app.scrollViews.otherElements.buttons["DeleteConfirmationDialogButton"]
		XCTAssertTrue(deleteConfirmationDialogButton.waitForExistence(timeout: 5))
	}

	/// Test final delete confirmation while first opening settings and then counters view
	func testDeleteConfirmationButton() {
		let app = XCUIApplication()
		app.launch()
		let settingsButton = app.buttons["SettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
		settingsButton.tap()
		let countersButton = app.navigationBars[Locale.current.language.languageCode == "en" ? "Settings" : ""].buttons["CountersButton"]
		XCTAssertTrue(countersButton.waitForExistence(timeout: 5))
		countersButton.tap()
		let todayText = app.collectionViews.staticTexts[Locale.current.language.languageCode == "en" ? "Today" : ""]
		XCTAssertTrue(todayText.waitForExistence(timeout: 5))
		todayText.swipeLeft()
		let deleteButton = app.collectionViews.buttons["DeleteButton"]
		XCTAssertTrue(deleteButton.waitForExistence(timeout: 5))
		deleteButton.tap()
		let deleteConfirmationDialogButton = app.scrollViews.otherElements.buttons["DeleteConfirmationDialogButton"]
		XCTAssertTrue(deleteConfirmationDialogButton.waitForExistence(timeout: 5))
		deleteConfirmationDialogButton.tap()
	}

	/// Test reset and confirm reset while first opening settings and then counters view
	func testResetButton() {
		let app = XCUIApplication()
		app.launch()
		let settingsButton = app.buttons["SettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
		settingsButton.tap()
		let countersButton = app.navigationBars[Locale.current.language.languageCode == "en" ? "Settings" : ""].buttons["CountersButton"]
		XCTAssertTrue(countersButton.waitForExistence(timeout: 5))
		countersButton.tap()
		let resetButton = app.navigationBars[Locale.current.language.languageCode == "en" ? "Counters" : ""].buttons["ResetButton"]
		XCTAssertTrue(resetButton.waitForExistence(timeout: 5))
		resetButton.tap()
		let resetConfirmationDialogButton = app.scrollViews.otherElements.buttons["ResetConfirmationDialogButton"]
		XCTAssertTrue(resetConfirmationDialogButton.waitForExistence(timeout: 5))
	}

	/// Test final reset confirmation while first opening settings and then counters view
	func testResetConfirmationButton() {
		let app = XCUIApplication()
		app.launch()
		let settingsButton = app.buttons["SettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
		settingsButton.tap()
		let countersButton = app.navigationBars[Locale.current.language.languageCode == "en" ? "Settings" : ""].buttons["CountersButton"]
		XCTAssertTrue(countersButton.waitForExistence(timeout: 5))
		countersButton.tap()
		let resetButton = app.navigationBars[Locale.current.language.languageCode == "en" ? "Counters" : ""].buttons["ResetButton"]
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

	/// Test close counters view while first opening settings and then counters view
	func testCloseCountersButton() {
		let app = XCUIApplication()
		app.launch()
		let settingsButton = app.buttons["SettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
		settingsButton.tap()
		let countersButton = app.navigationBars[Locale.current.language.languageCode == "en" ? "Settings" : ""].buttons["CountersButton"]
		XCTAssertTrue(countersButton.waitForExistence(timeout: 5))
		countersButton.tap()
		let closeCountersButton = app.navigationBars[Locale.current.language.languageCode == "en" ? "Counters" : ""].buttons["CloseCountersButton"]
		XCTAssertTrue(closeCountersButton.waitForExistence(timeout: 5))
		closeCountersButton.tap()
	}
}
