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

	/// Test close average view steps:
	/// 1) Close settings tip
	/// 2) Open settings view
	/// 3) Open average view
	/// 4) Close average view
	@MainActor
	func testCloseAverageButton() {
		let app = XCUIApplication()
		app.launch()
		app.closeSettingsTip()
		let settingsButton = app.buttons["SettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
		settingsButton.tap()
		let averageButton = app.buttons["AverageButton"]
		XCTAssertTrue(averageButton.waitForExistence(timeout: 5))
		averageButton.tap()
		let closeAverageButton = app.buttons["CloseAverageButton"]
		XCTAssertTrue(closeAverageButton.waitForExistence(timeout: 5))
		closeAverageButton.tap()
	}

	/// Test set selected average to 30 steps:
	/// 1) Close settings tip
	/// 2) Open settings view
	/// 3) Open average view
	/// 4) Set selected average to 30
	/// 5) Check `AverageMessage` for updated value
	@MainActor
	func testSelectAverageButton() {
		let app = XCUIApplication()
		app.launch()
		app.closeSettingsTip()
		let settingsButton = app.buttons["SettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
		settingsButton.tap()
		let averageButton = app.buttons["AverageButton"]
		XCTAssertTrue(averageButton.waitForExistence(timeout: 5))
		averageButton.tap()
		let averagePicker = app.buttons["AveragePicker"]
		XCTAssertTrue(averagePicker.waitForExistence(timeout: 5))
		averagePicker.tap()
		let thirtyButton = app.buttons["30"]
		XCTAssertTrue(thirtyButton.waitForExistence(timeout: 5))
		thirtyButton.tap()
		let averageMessage = app.staticTexts["AverageMessage"]
		XCTAssertTrue(averageMessage.waitForExistence(timeout: 5))
		XCTAssertTrue(averageMessage.label.contains("30"))
	}
}
