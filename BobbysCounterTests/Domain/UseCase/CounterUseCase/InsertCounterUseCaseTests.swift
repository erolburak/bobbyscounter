//
//  InsertCounterUseCaseTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 02.09.23.
//

@testable import BobbysCounter
import XCTest

class InsertCounterUseCaseTests: XCTestCase {

	// MARK: - Private Properties

	private var sut: InsertCounterUseCase!

	// MARK: - Life Cycle

	override func setUpWithError() throws {
		sut = InsertCounterUseCase()
	}

	override func tearDownWithError() throws {
		sut = nil
	}

	// MARK: - Actions

	func testInsertToday() async {
		// Given
		let selectedDate = Date.now
		let counter = Counter(count: 0,
							  date: selectedDate)
		// When
		let insertedCounter = await sut.insert(selectedDate: selectedDate)
		// Then
		XCTAssertEqual(insertedCounter?.count, counter.count)
		XCTAssertEqual(insertedCounter?.date.isDateToday, counter.date.isDateToday)
	}

	func testInsertYesterday() async {
		// Given
		let selectedDate = Calendar.current.date(byAdding: DateComponents(day: -1),
												 to: .now) ?? .now
		let counter = Counter(count: 0,
							  date: selectedDate)
		// When
		let insertedCounter = await sut.insert(selectedDate: selectedDate)
		// Then
		XCTAssertEqual(insertedCounter?.count, counter.count)
		XCTAssertEqual(insertedCounter?.date.isDateToday, counter.date.isDateToday)
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
