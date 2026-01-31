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
        incrementCount(with: app)
        decrementCount(with: app)
    }

    @MainActor
    private func decrementCount(with app: XCUIApplication) {
        /// Get count
        let count = app.getCount(with: app)
        /// Decrement count
        app.buttons["Minus"].waitForExistence().tap()
        /// Compare counts
        XCTAssertEqual(
            count - 1,
            app.getCount(with: app)
        )
    }

    @MainActor
    private func incrementCount(with app: XCUIApplication) {
        /// Get count
        let count = app.getCount(with: app)
        /// Increment count
        app.buttons["Plus"].waitForExistence().tap()
        /// Compare counts
        XCTAssertEqual(
            count + 1,
            app.getCount(with: app)
        )
    }
}
