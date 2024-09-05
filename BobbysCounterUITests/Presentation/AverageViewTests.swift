//
//  AverageViewTests.swift
//  BobbysCounterUITests
//
//  Created by Burak Erol on 28.01.24.
//

import XCTest

@MainActor
final class AverageViewTests: XCTestCase {
    // MARK: - Methods

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /// Test close average view steps:
    /// 1) Open settings view
    /// 2) Open average view
    /// 3) Close average view
    func testCloseAverageButton() {
        let app = XCUIApplication().appLaunch()
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
    /// 1) Open settings view
    /// 2) Open average view
    /// 3) Set selected average to 30
    /// 4) Check `AverageMessage` for updated value
    func testSelectAverageButton() {
        let app = XCUIApplication().appLaunch()
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
