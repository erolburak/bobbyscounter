//
//  FetchCounterUseCaseTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 02.09.23.
//

@testable import BobbysCounter
import XCTest

class FetchCounterUseCaseTests: XCTestCase {

	// MARK: - Private Properties

	private var sut: FetchCounterUseCase!

	// MARK: - Life Cycle

	override func setUpWithError() throws {
		sut = FetchCounterUseCase()
	}

	override func tearDownWithError() throws {
		sut = nil
	}

	// MARK: - Actions

	func testFetchIsNotNil() async {
		// Given
		let selectedDate = Date.now
		// When
		let counter = await sut.fetch(selectedDate: selectedDate)
		// Then
		XCTAssertNotNil(counter)
	}

	func testFetchIsNil() async {
		// Given
		let selectedDate = Calendar.current.date(byAdding: DateComponents(day: +1),
												 to: .now) ?? .now
		// When
		let counter = await sut.fetch(selectedDate: selectedDate)
		// Then
		XCTAssertNil(counter)
	}
}
