//
//  ContentViewTests.swift
//  BobbysCounterUITests
//
//  Created by Burak Erol on 24.07.23.
//

import XCTest

final class ContentViewTests: XCTestCase {
    // MARK: - Methods

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testContentView() {
        /// Launch app
        let app = XCUIApplication().appLaunch()
        app.checkDateText(with: app)
        increaseCount(with: app)
        decreaseCount(with: app)
    }

    @MainActor
    private func decreaseCount(with app: XCUIApplication) {
        /// Get count
        let count = app.getCount(with: app)
        /// Decrease count
        app.buttons["Minus"].tap()
        /// Compare counts
        XCTAssertEqual(
            count - 1,
            app.getCount(with: app)
        )
    }

    @MainActor
    private func increaseCount(with app: XCUIApplication) {
        /// Get count
        let count = app.getCount(with: app)
        /// Increase count
        app.buttons["Plus"].tap()
        /// Compare counts
        XCTAssertEqual(
            count + 1,
            app.getCount(with: app)
        )
    }
}
