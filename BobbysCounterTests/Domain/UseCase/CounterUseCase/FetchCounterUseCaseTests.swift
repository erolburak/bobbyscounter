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

	func testFetchCounterSelectedDateNow() async {
		// Given
		let selectedDate = Date.now
		// When
		let counter = await sut.fetch(selectedDate: selectedDate)
		// Then
		XCTAssertNotNil(counter)
	}

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
