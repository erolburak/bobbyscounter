//
//  DecreaseCounterCountUseCaseTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 02.09.23.
//

@testable import BobbysCounter
import XCTest

class DecreaseCounterCountUseCaseTests: XCTestCase {

	// MARK: - Private Properties

	private var sut: DecreaseCounterCountUseCase!

	// MARK: - Life Cycle

	override func setUpWithError() throws {
		sut = DecreaseCounterCountUseCase()
	}

	override func tearDownWithError() throws {
		sut = nil
	}

	// MARK: - Actions

	func testDecrease() {
		// Given
		let counter = Counter(count: 1,
							  date: .now)
		// When
		sut.decrease(counter: counter)
		// Then
		XCTAssertEqual(counter.count, 0)
	}

	func testDecreaseWithZero() {
		// Given
		let counter = Counter(count: 0,
							  date: .now)
		// When
		sut.decrease(counter: counter)
		// Then
		XCTAssertEqual(counter.count, 0)
	}
}
