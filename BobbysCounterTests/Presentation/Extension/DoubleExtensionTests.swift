//
//  DoubleExtensionTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 16.01.24.
//

@testable import BobbysCounter
import Testing

struct DoubleExtensionTests {

	// MARK: - Actions

	@Test("Check double to string formatter with 0.0!")
	func testToString() {
		// Given
		let double = 0.0
		// When
		let string = double.toString
		// Then
		#expect(string == "0",
				"Double to string formatter with 0.0 failed!")
	}

	@Test("Check double to string formatter with 0.006!")
	func testToStringWithThreeDigitsRounded() {
		// Given
		let double = 0.006
		// When
		let string = double.toString
		// Then
		#expect(string == "0.01",
				"Double to string formatter with 0.006 failed!")
	}
}
