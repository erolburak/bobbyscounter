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

	@MainActor
	func testFetchTodayIsNotNil() {
		// Given
		let selectedDate = Date.now
		let counter = Counter(count: 0,
							  date: selectedDate)
		DataController.shared.modelContainer.mainContext.insert(counter)
		// When
		let fetchedCounter = sut.fetch(selectedDate: selectedDate)
		// Then
		XCTAssertNotNil(fetchedCounter)
	}

	@MainActor
	func testFetchYesterdayIsNotNil() {
		// Given
		let selectedDate = Calendar.current.date(byAdding: DateComponents(day: -1),
												 to: .now) ?? .now
		let counter = Counter(count: 0,
							  date: selectedDate)
		DataController.shared.modelContainer.mainContext.insert(counter)
		// When
		let fetchedCounter = sut.fetch(selectedDate: selectedDate)
		// Then
		XCTAssertNotNil(fetchedCounter)
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
