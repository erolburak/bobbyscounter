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
        /// Set launch arguments to `-Testing`
        launchArguments = ["-Testing"]
        /// Launch app
        launch()
        /// Set device orientation to `portrait`
        XCUIDevice.shared.orientation = .portrait
        /// Insert new counter if needed
        let insertButton = buttons["InsertButton"]
        if insertButton.exists {
            insertButton.tap()
        }
        return self
    }

    func checkDateText(with app: XCUIApplication) {
        /// Check if `DateText` is set to `Today`
        XCTAssertEqual(app.staticTexts["DateText"].label, "Today")
    }

    func getCount(with app: XCUIApplication) -> Int {
        /// Get count
        Int(app.staticTexts["CountText"].label) ?? 0
    }

    func showSettingsView(with app: XCUIApplication) {
        /// Show settings view
        app.buttons["SettingsButton"].tap()
    }
}
