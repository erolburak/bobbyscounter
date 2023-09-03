//
//  InsertCounterUseCaseTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 02.09.23.
//

@testable import BobbysCounter
import XCTest

class InsertCounterUseCaseTests: XCTestCase {

	private var sut: InsertCounterUseCase!

	override func setUpWithError() throws {
		sut = InsertCounterUseCase()
	}

	override func tearDownWithError() throws {
		sut = nil
	}

	func testInsertCounterSelectedDateNow() async {
		// Given
		let selectedDate = Date.now
		let expected = Counter(count: 0,
							   date: selectedDate)
		// When
		let counter = await sut.insert(selectedDate: selectedDate)
		// Then
		XCTAssertEqual(counter?.count, expected.count)
		XCTAssertEqual(counter?.date.isDateToday, expected.date.isDateToday)
	}

	func testInsertCounterSelectedDateTomorrow() async {
		// Given
		let selectedDate = Calendar.current.date(byAdding: DateComponents(day: +1),
												 to: .now) ?? .now
		// When
		let counter = await sut.insert(selectedDate: selectedDate)
		// Then
		XCTAssertNil(counter)
	}
}
