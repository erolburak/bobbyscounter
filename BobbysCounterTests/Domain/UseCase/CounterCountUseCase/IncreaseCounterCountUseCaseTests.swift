//
//  IncreaseCounterCountUseCaseTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 02.09.23.
//

@testable import BobbysCounter
import XCTest

class IncreaseCounterCountUseCaseTests: XCTestCase {

	private var sut: IncreaseCounterCountUseCase!

	override func setUpWithError() throws {
		sut = IncreaseCounterCountUseCase()
	}

	override func tearDownWithError() throws {
		sut = nil
	}

	func testIncreaseCounterCount() {
		// Given
		let counter = Counter(count: 0,
							  date: .now)
		// When
		sut.increase(counter: counter)
		// Then
		XCTAssertEqual(counter.count, 1)
		XCTAssertEqual(counter.date.isDateToday, true)
	}
}
