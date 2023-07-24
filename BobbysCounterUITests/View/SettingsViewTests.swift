//
//  SettingsViewTests.swift
//  BobbysCounterUITests
//
//  Created by Burak Erol on 24.07.23.
//

import XCTest

final class SettingsViewTests: XCTestCase {

	override func setUpWithError() throws {
		continueAfterFailure = false
	}

	/// Test reset and confirm reset while first opening settings view
	func testResetButton() {
		let app = XCUIApplication()
		app.launch()
		app.buttons["SettingsButton"].tap()
		let resetButton = app.buttons["ResetButton"]
		XCTAssertTrue(resetButton.waitForExistence(timeout: 5))
		resetButton.tap()
		let resetConfirmationButton = app.buttons["ResetConfirmationButton"]
		XCTAssertTrue(resetConfirmationButton.waitForExistence(timeout: 5))
	}

	/// Test dismiss settings view while first opening settings view
	func testDismissButton() {
		let app = XCUIApplication()
		app.launch()
		app.buttons["SettingsButton"].tap()
		let dismissButton = app.buttons["DismissButton"]
		XCTAssertTrue(dismissButton.waitForExistence(timeout: 5))
		dismissButton.tap()
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
		let previousMonthButton = app.buttons["Previous Month"]
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
			XCTAssertEqual(dateText.label, "Today")
		}
	}

	/// Test final reset confirmation while first opening settings view
	func testResetConfirmationButton() {
		let app = XCUIApplication()
		app.launch()
		let settingsButton = app.buttons["SettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
		settingsButton.tap()
		let resetButton = app.buttons["ResetButton"]
		XCTAssertTrue(resetButton.waitForExistence(timeout: 5))
		resetButton.tap()
		let resetConfirmationButton = app.buttons["ResetConfirmationButton"]
		XCTAssertTrue(resetConfirmationButton.waitForExistence(timeout: 5))
		resetConfirmationButton.tap()
		let countText = app.staticTexts["CountText"]
		XCTAssertTrue(countText.waitForExistence(timeout: 5))
		let countTextAsInt = Int(app.staticTexts["CountText"].label)
		XCTAssertEqual(countTextAsInt, 0)
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
		settingsButton.tap()
		let chartDescriptionText = app.staticTexts["ChartDescriptionText"]
		XCTAssertTrue(chartDescriptionText.waitForExistence(timeout: 5))
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
		let previousMonthButton = app.buttons["Previous Month"]
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
	}
}
