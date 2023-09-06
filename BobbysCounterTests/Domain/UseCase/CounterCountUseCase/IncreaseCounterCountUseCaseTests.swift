//
//  IncreaseCounterCountUseCaseTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 02.09.23.
//

@testable import BobbysCounter
import XCTest

class IncreaseCounterCountUseCaseTests: XCTestCase {

	// MARK: - Private Properties

	private var sut: IncreaseCounterCountUseCase!

	// MARK: - Life Cycle

	override func setUpWithError() throws {
		sut = IncreaseCounterCountUseCase()
	}

	override func tearDownWithError() throws {
		sut = nil
	}

	// MARK: - Actions

	func testIncrease() {
		// Given
		let counter = Counter(count: 0,
							  date: .now)
		// When
		sut.increase(counter: counter)
		// Then
		XCTAssertEqual(counter.count, 1)
	}
}
