//
//  CounterSelectedTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 05.09.23.
//

@testable import BobbysCounter
import XCTest

class CounterSelectedTests: XCTestCase {

	// MARK: - Actions

	func testCounterSelected() {
		// Given
		let counterSelected: CounterSelected?
		// When
		counterSelected = CounterSelected()
		// Then
		XCTAssertNotNil(counterSelected)
	}
}
