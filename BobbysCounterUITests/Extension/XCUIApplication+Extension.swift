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
    /// 1) Set launch arguments to -uitesting
    /// 2) Close settings tip
    func appLaunch() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["–uitesting"]
        app.launch()
        let closeSettingsTipButton = popovers.buttons["Close"]
        if closeSettingsTipButton.waitForExistence(timeout: 5) {
            closeSettingsTipButton.tap()
        }
        return app
    }
}
