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

	func testInsert() async {
		// Given
		let selectedDate = Date.now
		let counter = Counter(count: 0,
							  date: selectedDate)
		// When
		let newCounter = await sut.insert(selectedDate: selectedDate)
		// Then
		XCTAssertEqual(newCounter?.count, counter.count)
		XCTAssertEqual(newCounter?.date.isDateToday, counter.date.isDateToday)
	}

	func testInsertTomorrowIsNil() async {
		// Given
		let selectedDate = Calendar.current.date(byAdding: DateComponents(day: +1),
												 to: .now) ?? .now
		// When
		let counter = await sut.insert(selectedDate: selectedDate)
		// Then
		XCTAssertNil(counter)
	}
}
