//
//  AverageViewTests.swift
//  BobbysCounterUITests
//
//  Created by Burak Erol on 28.01.24.
//

import XCTest

final class AverageViewTests: XCTestCase {

	// MARK: - Actions

	override func setUpWithError() throws {
		continueAfterFailure = false
	}

	/// Test close average view while first opening settings and then average view
	@MainActor
	func testCloseAverageButton() {
		let app = XCUIApplication()
		app.launch()
		let settingsButton = app.buttons["SettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
		settingsButton.tap()
		let averageButton = app.navigationBars[Locale.current.language.languageCode == "en" ? "Settings" : ""].buttons["AverageButton"]
		XCTAssertTrue(averageButton.waitForExistence(timeout: 5))
		averageButton.tap()
		let closeAverageButton = app.navigationBars[Locale.current.language.languageCode == "en" ? "Average" : ""].buttons["CloseAverageButton"]
		XCTAssertTrue(closeAverageButton.waitForExistence(timeout: 5))
		closeAverageButton.tap()
	}

	/// Test set selected average to 30 while first opening settings view and then average view
	@MainActor
	func testSelectAverageButton() {
		let app = XCUIApplication()
		app.launch()
		let settingsButton = app.buttons["SettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
		settingsButton.tap()
		let averageButton = app.navigationBars[Locale.current.language.languageCode == "en" ? "Settings" : ""].buttons["AverageButton"]
		XCTAssertTrue(averageButton.waitForExistence(timeout: 5))
		averageButton.tap()
		let averagePicker = app.buttons["AveragePicker"]
		XCTAssertTrue(averagePicker.waitForExistence(timeout: 5))
		averagePicker.tap()
		let thirtyButton = app.buttons["30"]
		XCTAssertTrue(thirtyButton.waitForExistence(timeout: 5))
		thirtyButton.tap()
		let todayButton = app.buttons["TodayButton"]
		XCTAssertTrue(todayButton.waitForExistence(timeout: 5))
		let averageMessage = app.staticTexts["AverageMessage"]
		XCTAssertTrue(averageMessage.waitForExistence(timeout: 5))
		XCTAssertTrue(averageMessage.label.contains("30"))
	}
}
