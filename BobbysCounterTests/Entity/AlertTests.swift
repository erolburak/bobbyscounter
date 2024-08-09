//
//  AlertTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 13.12.23.
//

@testable import BobbysCounter
import Testing

struct AlertTests {

	// MARK: - Actions

	@Test("Check initializing Alert!")
	func testAlert() {
		// Given
		let alert: Alert?
		// When
		alert = Alert()
		// Then
		#expect(alert != nil,
				"Initializing Alert failed!")
	}
}
