//
//  DecreaseCounterCountUseCaseTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 02.09.23.
//

@testable import BobbysCounter
import XCTest

class DecreaseCounterCountUseCaseTests: XCTestCase {

	private var sut: DecreaseCounterCountUseCase!

	override func setUpWithError() throws {
		sut = DecreaseCounterCountUseCase()
	}

	override func tearDownWithError() throws {
		sut = nil
	}

	func testDecreaseCounterCount() {
		// Given
		let counter = Counter(count: 1,
							  date: .now)
		// When
		sut.decrease(counter: counter)
		// Then
		XCTAssertEqual(counter.count, 0)
		XCTAssertEqual(counter.date.isDateToday, true)
	}

	func testDecreaseCounterCountZero() {
		// Given
		let counter = Counter(count: 0,
							  date: .now)
		// When
		sut.decrease(counter: counter)
		// Then
		XCTAssertEqual(counter.count, 0)
		XCTAssertEqual(counter.date.isDateToday, true)
	}
}
