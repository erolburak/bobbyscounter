//
//  ContentViewModelTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 22.07.23.
//

@testable import BobbysCounter
import XCTest

class ContentViewModelTests: XCTestCase {

	// MARK: - Private Properties

	private var sut: ContentViewModel!

	// MARK: - Life Cycle

	override func setUpWithError() throws {
		sut = ContentViewModel(decreaseCounterCountUseCase: DecreaseCounterCountUseCase(),
							   fetchCounterUseCase: FetchCounterUseCase(),
							   increaseCounterCountUseCase: IncreaseCounterCountUseCase(),
							   insertCounterUseCase: InsertCounterUseCase())
	}

	override func tearDownWithError() throws {
		sut = nil
	}

	// MARK: - Actions

	func testContentViewModelIsNotNil() async {
		// When
		let contentViewModel = ContentViewModel(decreaseCounterCountUseCase: DecreaseCounterCountUseCase(),
												fetchCounterUseCase: FetchCounterUseCase(),
								 increaseCounterCountUseCase: IncreaseCounterCountUseCase(),
								 insertCounterUseCase: InsertCounterUseCase())
		// Then
		XCTAssertNotNil(contentViewModel)
	}

	func testDecreaseCounterCount() {
		// Given
		sut.counterSelected.counter = Counter(count: 1,
											  date: .now)
		// When
		sut.decreaseCounterCount()
		// Then
		XCTAssertEqual(sut.counterSelected.counter?.count, 0)
	}

	func testIncreaseCounterCount() {
		// Given
		sut.counterSelected.counter = Counter(count: 0,
											  date: .now)
		// When
		sut.increaseCounterCount()
		// Then
		XCTAssertEqual(sut.counterSelected.counter?.count, 1)
	}

	func testFetchCounter() {
		// Given
		sut.counterSelected.selectedDate = .now
		sut.counterSelected.counter = Counter(count: 0,
											  date: Calendar.current.date(byAdding: DateComponents(day: -1),
																		  to: .now) ?? .now)
		// When
		sut.fetchCounter()
		// Then
		XCTAssertTrue(sut.counterSelected.counter?.date.isDateToday ?? false)
	}
}
