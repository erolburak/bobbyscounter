//
//  XCUIApplication+Extension.swift
//  BobbysCounterUITests
//
//  Created by Burak Erol on 23.05.24.
//

import XCTest

extension XCUIApplication {

	// MARK: - Actions

	/// Detects if settings tip is visible and closes it
	func closeSettingsTip() {
		let closeSettingsTipButton = self.popovers.buttons["Close"]
		if closeSettingsTipButton.waitForExistence(timeout: 5) {
			closeSettingsTipButton.tap()
		}
	}
}
