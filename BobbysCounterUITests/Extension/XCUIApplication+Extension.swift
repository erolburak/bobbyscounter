//
//  XCUIApplication+Extension.swift
//  BobbysCounterUITests
//
//  Created by Burak Erol on 23.05.24.
//

import XCTest

extension XCUIApplication {
    // MARK: - Methods

    /// Detects if settings tip is visible and closes it
    func closeSettingsTip() {
        let closeSettingsTipButton = popovers.buttons["Close"]
        if closeSettingsTipButton.waitForExistence(timeout: 5) {
            closeSettingsTipButton.tap()
        }
    }
}
