//
//  DoubleExtensionTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 16.01.24.
//

@testable import BobbysCounter
import XCTest

class DoubleExtensionTests: XCTestCase {

	// MARK: - Actions

	func testToString() {
		// Given
		let double = 0.0
		// When
		let string = double.toString
		// Then
		XCTAssertEqual(string, "0")
	}

	func testToStringWithThreeDigitsRounded() {
		// Given
		let double = 0.006
		// When
		let string = double.toString
		// Then
		XCTAssertEqual(string, "0.01")
	}
}
