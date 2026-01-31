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
        /// Add new category if needed
        if buttons[Accessibility.showCategoryAddButton.id].exists {
            addNewCategory(with: self)
        }
        /// Add new counter if needed
        if buttons[Accessibility.showCategoryAddButton.id].exists {
            addNewCounter(with: self)
        }
        return self
    }

    func addNewCategory(with app: XCUIApplication) {
        /// Add new category
        app.buttons[Accessibility.showCategoryAddButton.id].waitForExistence().tap()
        /// Set category to `Test`
        let textField = app.textFields.firstMatch.waitForExistence()
        textField.doubleTap()
        textField.typeText("Test")
        /// Confirm selected category
        app.buttons[Accessibility.categoryAlertConfirmButton.id].firstMatch.waitForExistence().tap()
    }

    func addNewCounter(with app: XCUIApplication) {
        /// Add new counter
        app.buttons[Accessibility.addCounterButton.id].waitForExistence().tap()
    }

    func getCount(with app: XCUIApplication) -> Int {
        /// Get count
        Int(app.staticTexts[Accessibility.countText.id].label) ?? 0
    }

    func showSettingsView(with app: XCUIApplication) {
        /// Show settings view
        app.buttons[Accessibility.settingsButton.id].waitForExistence().tap()
    }

    func showSettingsMenu(with app: XCUIApplication) {
        /// Show settings view
        app.showSettingsView(with: app)
        /// Show settings menu
        app.buttons[Accessibility.settingsMenu.id].waitForExistence().tap()
    }
}
