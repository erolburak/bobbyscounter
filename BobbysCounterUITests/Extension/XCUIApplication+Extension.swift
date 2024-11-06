//
//  XCUIApplication+Extension.swift
//  BobbysCounterUITests
//
//  Created by Burak Erol on 23.05.24.
//

import XCTest

extension XCUIApplication {
    // MARK: - Methods

    /// Launch app steps:
    /// 1) Set launch arguments to -testing
    /// 2) Close settings tip
    func appLaunch() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-testing"]
        app.launch()
        let closeSettingsTipButton = popovers.buttons["Close"]
        if closeSettingsTipButton.waitForExistence(timeout: 5) {
            closeSettingsTipButton.tap()
        }
        return app
    }
}
