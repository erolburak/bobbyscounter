//
//  FetchCounterUseCaseTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 02.09.23.
//

@testable import BobbysCounter
import XCTest

class FetchCounterUseCaseTests: XCTestCase {

	private var sut: FetchCounterUseCase!

	override func setUpWithError() throws {
		sut = FetchCounterUseCase()
	}

	override func tearDownWithError() throws {
		sut = nil
	}

	/// Test fetch counter with selected date is now
	func testFetchCounterSelectedDateNow() async {
		// Given
		let selectedDate = Date.now
		// When
		let counter = await sut.fetch(selectedDate: selectedDate)
		// Then
		XCTAssertNotNil(counter)
	}

	/// Test fetch counter with selected date is tomorrow
	func testFetchCounterSelectedDateTomorrow() async {
		// Given
		let selectedDate = Calendar.current.date(byAdding: DateComponents(day: +1),
												 to: .now) ?? .now
		// When
		let counter = await sut.fetch(selectedDate: selectedDate)
		// Then
		XCTAssertNil(counter)
	}
}
