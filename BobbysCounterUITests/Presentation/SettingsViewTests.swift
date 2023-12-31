//
//  SettingsViewTests.swift
//  BobbysCounterUITests
//
//  Created by Burak Erol on 24.07.23.
//

import XCTest

final class SettingsViewTests: XCTestCase {

	// MARK: - Life Cycle

	override func setUpWithError() throws {
		continueAfterFailure = false
	}

	// MARK: - Actions

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

	/// Test close settings view while first opening settings view
	func testCloseSettingsButton() {
		let app = XCUIApplication()
		app.launch()
		let settingsButton = app.buttons["SettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
		settingsButton.tap()
		let closeSettingsButton = app.buttons["CloseSettingsButton"]
		XCTAssertTrue(closeSettingsButton.waitForExistence(timeout: 5))
		closeSettingsButton.tap()
	}

	/// Test set selected date to today while first opening settings view
	/// Afterwards select first day of previous month and then select today
	func testTodayButton() {
		let app = XCUIApplication()
		app.launch()
		let settingsButton = app.buttons["SettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
		settingsButton.tap()
		let datePicker = app.datePickers["DatePicker"]
		XCTAssertTrue(datePicker.waitForExistence(timeout: 5))
		datePicker.tap()
		let previousMonthButton = app.buttons[Locale.current.language.languageCode == "en" ? "Previous Month" : ""]
		XCTAssertTrue(previousMonthButton.waitForExistence(timeout: 5))
		previousMonthButton.tap()
		let firstDayOfMonthButton = app.datePickers.collectionViews.staticTexts["1"]
		XCTAssertTrue(previousMonthButton.waitForExistence(timeout: 5))
		firstDayOfMonthButton.tap()
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
		settingsButton.tap()
		let todayButton = app.buttons["TodayButton"]
		XCTAssertTrue(todayButton.waitForExistence(timeout: 5))
		if todayButton.isEnabled {
			todayButton.tap()
			let dateText = app.staticTexts["DateText"]
			XCTAssertTrue(dateText.waitForExistence(timeout: 5))
			XCTAssertEqual(dateText.label, Locale.current.language.languageCode == "en" ? "Today" : "")
		}
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
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
		settingsButton.tap()
		let emptyChartsMessage = app.staticTexts["EmptyChartsMessage"]
		XCTAssertTrue(emptyChartsMessage.waitForExistence(timeout: 5))
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

	/// Test if `Chart` exists while first increasing counter count value for current day
	/// Then increasing counter count value for first day of previous month and then opening settings view
	func testChart() {
		let app = XCUIApplication()
		app.launch()
		let plusButton = app.buttons["PlusButton"]
		XCTAssertTrue(plusButton.waitForExistence(timeout: 5))
		plusButton.tap()
		let settingsButton = app.buttons["SettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
		settingsButton.tap()
		let datePicker = app.datePickers["DatePicker"]
		XCTAssertTrue(datePicker.waitForExistence(timeout: 5))
		datePicker.tap()
		let previousMonthButton = app.buttons[Locale.current.language.languageCode == "en" ? "Previous Month" : ""]
		XCTAssertTrue(previousMonthButton.waitForExistence(timeout: 5))
		previousMonthButton.tap()
		let firstDayOfMonthButton = app.datePickers.collectionViews.staticTexts["1"]
		XCTAssertTrue(previousMonthButton.waitForExistence(timeout: 5))
		firstDayOfMonthButton.tap()
		XCTAssertTrue(plusButton.waitForExistence(timeout: 5))
		plusButton.tap()
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
		settingsButton.tap()
		let chart = app.scrollViews["Chart"]
		XCTAssertTrue(chart.waitForExistence(timeout: 5))
		let pointMark = app.scrollViews["Chart"].children(matching: .other).element.children(matching: .other).element(boundBy: 0)
		XCTAssertTrue(pointMark.waitForExistence(timeout: 5))
		pointMark.press(forDuration: 2)
	}
}
