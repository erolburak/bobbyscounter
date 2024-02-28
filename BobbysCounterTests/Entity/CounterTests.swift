//
//  CounterTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 05.09.23.
//

@testable import BobbysCounter
import XCTest

class CounterTests: XCTestCase {

	// MARK: - Actions
	
	func testCounter() {
		// Given
		let counter: Counter?
		// When
		counter = Counter(count: 0,
						  date: .now)
		// Then
		XCTAssertNotNil(counter)
	}

	func testDecrease() {
		// Given
		let counter = Counter(count: 1,
							  date: .now)
		// When
		counter.decrease()
		// Then
		XCTAssertEqual(counter.count, 0)
	}

	func testDecreaseWithZero() {
		// Given
		let counter = Counter(count: 0,
							  date: .now)
		// When
		counter.decrease()
		// Then
		XCTAssertEqual(counter.count, 0)
	}

	func testIncrease() {
		// Given
		let counter = Counter(count: 0,
							  date: .now)
		// When
		counter.increase()
		// Then
		XCTAssertEqual(counter.count, 1)
	}
}
