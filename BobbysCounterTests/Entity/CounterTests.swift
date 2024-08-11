//
//  CounterTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 05.09.23.
//

import Foundation
import Testing

struct CounterTests {

	// MARK: - Actions
	
	@Test("Check Counter initializing!")
	func testCounter() {
		// Given
		let counter: Counter?
		// When
		counter = Counter(count: 0,
						  date: .now)
		// Then
		#expect(counter != nil,
				"Counter initializing failed!")
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

	@Test("Check Counter fetch!")
	@MainActor
	func testFetch() async throws {
		// Given
		let date = Calendar.current.date(byAdding: DateComponents(day: -2),
										 to: .now) ?? .now
		// When
		let counter = try await Counter.fetch(date: date)
		// Then
		#expect(counter != nil,
				"Counter fetch failed!")
	}
}
