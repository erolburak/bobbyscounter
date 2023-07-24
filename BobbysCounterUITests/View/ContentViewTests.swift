//
//  ContentViewTests.swift
//  BobbysCounterUITests
//
//  Created by Burak Erol on 24.07.23.
//

import XCTest

final class ContentViewTests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

	func testDecreaseCountText() {
		let app = XCUIApplication()
		app.launch()
		let currentCountTextAsInt = Int(app.staticTexts["CountText"].label)
		XCTAssertNotNil(currentCountTextAsInt)
		let minusButton = app.buttons["MinusButton"]
		XCTAssertTrue(minusButton.waitForExistence(timeout: 5))
		if minusButton.isEnabled {
			minusButton.tap()
			let newCountTextAsInt = Int(app.staticTexts["CountText"].label)
			XCTAssertEqual(currentCountTextAsInt!-1, newCountTextAsInt)
		} else {
			XCTAssertEqual(currentCountTextAsInt!, 0)
		}
	}

	func testIncreaseCountText() {
		let app = XCUIApplication()
		app.launch()
		let currentCountTextAsInt = Int(app.staticTexts["CountText"].label)
		XCTAssertNotNil(currentCountTextAsInt)
		let plusButton = app.buttons["PlusButton"]
		XCTAssertTrue(plusButton.waitForExistence(timeout: 5))
		plusButton.tap()
		let newCountTextAsInt = Int(app.staticTexts["CountText"].label)
		XCTAssertEqual(currentCountTextAsInt!+1, newCountTextAsInt)
	}

	func testDateText() {
		let app = XCUIApplication()
		app.launch()
		let dateText = app.staticTexts["DateText"]
		XCTAssertTrue(dateText.waitForExistence(timeout: 5))
		XCTAssertEqual(dateText.label, "Today")
	}

	func testSettingsButton() {
		let app = XCUIApplication()
		app.launch()
		let settingsButton = app.buttons["SettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
		XCTAssertTrue(settingsButton.isEnabled)
	}
}
