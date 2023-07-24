//
//  ContentViewModelTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 22.07.23.
//

@testable import BobbysCounter
import XCTest

class ContentViewModelTests: XCTestCase {

	private var sut: ContentViewModel!

	override func setUpWithError() throws {
		sut = ContentViewModel()
	}

	override func tearDownWithError() throws {
		sut = nil
	}

	func testDecreaseCount() {
		// Given
		sut.counter = Counter(count: 1,
							  date: .now)
		let expected = 0
		// When
		sut.decreaseCount()
		// Then
		XCTAssertEqual(sut.counter?.count, expected)
	}

	func testIncreaseCount() {
		// Given
		sut.counter = Counter(count: 0,
							  date: .now)
		let expected = 1
		// When
		sut.increaseCount()
		// Then
		XCTAssertEqual(sut.counter?.count, expected)
	}

	func testSetCount() async throws {
		// Given
		let expected = sut.counter?.count
		// When
		try await sut.setCount()
		// Then
		XCTAssertEqual(sut.counter?.count, expected)
	}

	func testSetCounter() async throws {
		// Given
		let expected = Counter(count: 0,
							   date: .now)
		let counters = [expected,
						Counter(count: 1,
								date: Calendar.current.date(byAdding: DateComponents(day: -1),
															to: .now) ?? .now),
						Counter(count: 2,
								date: Calendar.current.date(byAdding: DateComponents(day: 1),
															to: .now) ?? .now)]
		// When
		try await sut.setCounter(counters: counters)
		// Then
		XCTAssertEqual(sut.counter, expected)
		XCTAssertNotEqual(sut.counter, counters.last)
	}
}
