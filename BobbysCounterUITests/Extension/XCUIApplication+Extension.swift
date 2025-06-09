//
//  XCUIApplication+Extension.swift
//  BobbysCounterUITests
//
//  Created by Burak Erol on 23.05.24.
//

import XCTest

extension XCUIApplication {
    // MARK: - Methods

    func appLaunch() -> XCUIApplication {
        let app = XCUIApplication()
        /// Set launch arguments to `-testing`
        app.launchArguments = ["-testing"]
        /// Launch app
        app.launch()
        /// Insert new counter if needed
        let insertButton = app.buttons["InsertButton"]
        if insertButton.waitForExistence(timeout: 1) {
            insertButton.tap()
        }
        return app
    }

    func checkDateText(with app: XCUIApplication) {
        /// Check if `DateText` is set to `Today`
        let dateText = app.staticTexts["DateText"]
        XCTAssertTrue(dateText.waitForExistence(timeout: 1))
        XCTAssertEqual(dateText.label, "Today")
    }

    func getCount(with app: XCUIApplication) -> Int {
        /// Get count
        let countText = app.staticTexts["CountText"]
        XCTAssertTrue(countText.waitForExistence(timeout: 1))
        return Int(countText.label) ?? 0
    }

    func openSettingsView(with app: XCUIApplication) {
        /// Open settings view
        let settingsButton = app.buttons["SettingsButton"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 1))
        settingsButton.tap()
    }
}
