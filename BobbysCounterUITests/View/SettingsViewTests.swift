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

	func testDismissButton() {
		let app = XCUIApplication()
		app.launch()
		app.buttons["SettingsButton"].tap()
		let dismissButton = app.buttons["DismissButton"]
		XCTAssertTrue(dismissButton.waitForExistence(timeout: 5))
		dismissButton.tap()
	}

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

	func testResetConfirmationButton() {
		let app = XCUIApplication()
		app.launch()
		app.buttons["SettingsButton"].tap()
		let resetButton = app.buttons["ResetButton"]
		XCTAssertNotNil(resetButton)
		resetButton.tap()
		let resetConfirmationButton = app.buttons["ResetConfirmationButton"]
		XCTAssertTrue(resetConfirmationButton.waitForExistence(timeout: 5))
		resetConfirmationButton.tap()
		let countText = app.staticTexts["CountText"]
		XCTAssertTrue(countText.waitForExistence(timeout: 5))
		let countTextAsInt = Int(app.staticTexts["CountText"].label)
		XCTAssertEqual(countTextAsInt, 0)
	}
}
