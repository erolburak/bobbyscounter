//
//  AlertTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 13.12.23.
//

@testable import BobbysCounter
import XCTest

class AlertTests: XCTestCase {

	// MARK: - Actions

	func testAlert() {
		// Given
		let alert: Alert?
		// When
		alert = Alert()
		// Then
		XCTAssertNotNil(alert)
	}
}
