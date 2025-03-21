//
//  BobbysCounterUITests.swift
//  BobbysCounterUITests
//
//  Created by Burak Erol on 27.06.23.
//

import XCTest

final class BobbysCounterUITests: XCTestCase {
    // MARK: - Methods

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
