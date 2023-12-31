//
//  ContentViewTests.swift
//  BobbysCounterUITests
//
//  Created by Burak Erol on 24.07.23.
//

import XCTest

final class ContentViewTests: XCTestCase {

	// MARK: - Life Cycle

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

	// MARK: - Actions

	/// Test decrease counter count value if `MinusButton` is enabled
	/// Check `CountText` for updated value otherwise check if `CountText` is 0
	func testDecreaseCountText() {
		let app = XCUIApplication()
		app.launch()
		let currentCountTest = app.staticTexts["CountText"]
		XCTAssertTrue(currentCountTest.waitForExistence(timeout: 5))
		let currentCountTextAsInt = Int(currentCountTest.label)
		XCTAssertNotNil(currentCountTextAsInt)
		let minusButton = app.buttons["MinusButton"]
		XCTAssertTrue(minusButton.waitForExistence(timeout: 5))
		if let currentCountTextAsInt,
		   minusButton.isEnabled {
			minusButton.tap()
			let newCountText = app.staticTexts["CountText"]
			XCTAssertTrue(newCountText.waitForExistence(timeout: 5))
			let newCountTextAsInt = Int(newCountText.label)
			XCTAssertEqual(currentCountTextAsInt-1, newCountTextAsInt)
		} else {
			XCTAssertEqual(currentCountTextAsInt, 0)
		}
	}

	/// Test increase counter count value
	/// Check `CountText` for updated value
	func testIncreaseCountText() {
		let app = XCUIApplication()
		app.launch()
		let currentCountTest = app.staticTexts["CountText"]
		XCTAssertTrue(currentCountTest.waitForExistence(timeout: 5))
		let currentCountTextAsInt = Int(currentCountTest.label)
		XCTAssertNotNil(currentCountTextAsInt)
		let plusButton = app.buttons["PlusButton"]
		XCTAssertTrue(plusButton.waitForExistence(timeout: 5))
		if let currentCountTextAsInt {
			plusButton.tap()
			let newCountText = app.staticTexts["CountText"]
			XCTAssertTrue(newCountText.waitForExistence(timeout: 5))
			let newCountTextAsInt = Int(newCountText.label)
			XCTAssertEqual(currentCountTextAsInt+1, newCountTextAsInt)
		}
	}

	/// Test if `DateText` is set to today after launch
	func testDateText() {
		let app = XCUIApplication()
		app.launch()
		let dateText = app.staticTexts["DateText"]
		XCTAssertTrue(dateText.waitForExistence(timeout: 5))
		XCTAssertEqual(dateText.label, Locale.current.language.languageCode == "en" ? "Today" : "")
	}

	/// Test if `SettingsButton` exists and is enabled
	func testSettingsButton() {
		let app = XCUIApplication()
		app.launch()
		let settingsButton = app.buttons["SettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
		XCTAssertTrue(settingsButton.isEnabled)
	}
}
