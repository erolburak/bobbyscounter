//
//  AverageViewTests.swift
//  BobbysCounterUITests
//
//  Created by Burak Erol on 28.01.24.
//

import XCTest

final class AverageViewTests: XCTestCase {
    // MARK: - Methods

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testAverageView() {
        /// Launch app
        let app = XCUIApplication().appLaunch()
        app.openSettingsView(with: app)
        openAverageView(with: app)
        changeAverage(with: app)
        closeAverageView(with: app)
    }

    @MainActor
    private func closeAverageView(with app: XCUIApplication) {
        /// Close average view
        let closeAverageButton = app.buttons["CloseAverageButton"]
        XCTAssertTrue(closeAverageButton.waitForExistence(timeout: 5))
        closeAverageButton.tap()
    }

    @MainActor
    private func changeAverage(with app: XCUIApplication) {
        /// Open average picker
        let averagePicker = app.buttons["AveragePicker"]
        XCTAssertTrue(averagePicker.waitForExistence(timeout: 5))
        averagePicker.tap()
        /// Change average to `30`
        let thirtyButton = app.buttons["30"]
        XCTAssertTrue(thirtyButton.waitForExistence(timeout: 5))
        thirtyButton.tap()
        /// Check if `AverageMessage` contains `30`
        let averageMessage = app.staticTexts["AverageMessage"]
        XCTAssertTrue(averageMessage.waitForExistence(timeout: 5))
        XCTAssertTrue(averageMessage.label.contains("30"))
    }

    @MainActor
    private func openAverageView(with app: XCUIApplication) {
        /// Open average view
        let averageButton = app.buttons["AverageButton"]
        XCTAssertTrue(averageButton.waitForExistence(timeout: 5))
        averageButton.tap()
    }
}
