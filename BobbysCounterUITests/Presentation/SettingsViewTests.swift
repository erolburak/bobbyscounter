//
//  SettingsViewTests.swift
//  BobbysCounterUITests
//
//  Created by Burak Erol on 24.07.23.
//

import XCTest

final class SettingsViewTests: XCTestCase {

	// MARK: - Actions

	override func setUpWithError() throws {
		continueAfterFailure = false
	}

	/// Test close settings view steps:
	/// 1) Close settings tip
	/// 2) Open settings view
	/// 3) Close settings view
	@MainActor
	func testCloseSettingsButton() {
		let app = XCUIApplication()
		app.launch()
		app.closeSettingsTip()
		let settingsButton = app.buttons["SettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
		settingsButton.tap()
		let closeSettingsButton = app.buttons["CloseSettingsButton"]
		XCTAssertTrue(closeSettingsButton.waitForExistence(timeout: 5))
		closeSettingsButton.tap()
	}

	/// Test set selected date to today steps:
	/// 1) Close settings tip
	/// 2) Open settings view
	/// 3) Select first day of previous month
	/// 4) Select today
	/// 5) Check `DateText` for updated value
	@MainActor
	func testTodayButton() {
		let app = XCUIApplication()
		app.launch()
		app.closeSettingsTip()
		let settingsButton = app.buttons["SettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
		settingsButton.tap()
		let datePicker = app.datePickers["DatePicker"]
		XCTAssertTrue(datePicker.waitForExistence(timeout: 5))
		datePicker.tap()
		let previousMonthButton = app.buttons["Previous Month"]
		XCTAssertTrue(previousMonthButton.waitForExistence(timeout: 5))
		previousMonthButton.tap()
		let firstDayOfMonthButton = app.staticTexts["1"]
		XCTAssertTrue(previousMonthButton.waitForExistence(timeout: 5))
		firstDayOfMonthButton.tap()
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
		settingsButton.tap()
		let todayButton = app.buttons["TodayButton"]
		XCTAssertTrue(todayButton.waitForExistence(timeout: 5))
		todayButton.tap()
		let dateText = app.staticTexts["DateText"]
		XCTAssertTrue(dateText.waitForExistence(timeout: 5))
		XCTAssertEqual(dateText.label, "Today")
	}
}
