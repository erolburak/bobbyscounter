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

	/// Test close settings view while first opening settings view
	@MainActor
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
	/// Then select first day of previous month and then select today
	@MainActor
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
}
