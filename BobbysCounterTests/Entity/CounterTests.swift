//
//  CounterTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 05.09.23.
//

@testable import BobbysCounter
import Testing

struct CounterTests {

	// MARK: - Actions
	
	@Test("Check initializing Counter!")
	func testCounter() {
		// Given
		let counter: Counter?
		// When
		counter = Counter(count: 0,
						  date: .now)
		// Then
		#expect(counter != nil,
				"Initializing Counter failed!")
	}

	@Test("Check Counter decrease!")
	func testDecrease() throws {
		// Given
		let counter = Counter(count: 1,
							  date: .now)
		// When
		try counter.decrease()
		// Then
		#expect(counter.count == 0,
				"Counter decrease failed!")
	}

	@Test("Check Counter decrease with zero!")
	func testDecreaseWithZero() throws {
		// Given
		let counter = Counter(count: 0,
							  date: .now)
		// When
		try counter.decrease()
		// Then
		#expect(counter.count == 0,
				"Counter decrease with zero failed!")
	}

	@Test("Check Counter increase!")
	func testIncrease() throws {
		// Given
		let counter = Counter(count: 0,
							  date: .now)
		// When
		try counter.increase()
		// Then
		#expect(counter.count == 1,
				"Counter increase failed!")
	}
}
