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
        app.showSettingsMenu(with: app)
        showAverageView(with: app)
        changeAverage(with: app)
        closeAverageView(with: app)
    }

    @MainActor
    private func closeAverageView(with app: XCUIApplication) {
        /// Close average view
        app.buttons[Accessibility.closeAverageButton.id].waitForExistence().tap()
    }

    @MainActor
    private func changeAverage(with app: XCUIApplication) {
        /// Change average to `30`
        app.buttons["30"].waitForExistence().tap()
        /// Check if `AverageMessage` contains `30`
        XCTAssertTrue(app.staticTexts[Accessibility.averageMessage.id].label.contains("30"))
    }

    @MainActor
    private func showAverageView(with app: XCUIApplication) {
        /// Show average view
        app.buttons[Accessibility.averageButton.id].waitForExistence().tap()
    }
}
