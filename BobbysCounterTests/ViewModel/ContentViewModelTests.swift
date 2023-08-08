//
//  ContentViewModelTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 22.07.23.
//

@testable import BobbysCounter
import XCTest

class ContentViewModelTests: XCTestCase {

	private var sut: ContentViewModel!

	override func setUpWithError() throws {
		sut = ContentViewModel()
	}

	override func tearDownWithError() throws {
		sut = nil
	}

	/// Test decrease counter count value
	func testDecreaseCount() {
		// Given
		sut.counter = Counter(count: 1,
							  date: .now)
		// When
		sut.decreaseCount()
		// Then
		XCTAssertEqual(sut.counter?.count, 0)
	}

	/// Test increase counter count value
	func testIncreaseCount() {
		// Given
		sut.counter = Counter(count: 0,
							  date: .now)
		// When
		sut.increaseCount()
		// Then
		XCTAssertEqual(sut.counter?.count, 1)
	}

	/// Test fetch counter count value
	func testFetchCount() async throws {
		// Given
		sut.counter = Counter(count: 0,
							  date: .now)
		// When
		let count = try await sut.fetchCount()
		// Then
		XCTAssertEqual(sut.counter?.count, 0)
	}

	/// Test set counter
	func testSetCounter() async throws {
		// Given
		let expected = Counter(count: 0,
							   date: .now)
		let countersMock = [expected,
							Counter(count: 1,
									date: Calendar.current.date(byAdding: DateComponents(day: -1),
																to: .now) ?? .now),
							Counter(count: 2,
									date: Calendar.current.date(byAdding: DateComponents(day: 1),
																to: .now) ?? .now)]
		// When
		try await sut.setCounter(counters: countersMock)
		// Then
		XCTAssertEqual(sut.counter, expected)
		XCTAssertNotEqual(sut.counter, countersMock.last)
	}

	/// Test all alert errors
	func testAlertErrors() {
		for error in Constant.Errors.allCases {
			testAlertError(error: error)
		}
	}

	/// Test all alert errors helper
	private func testAlertError(error: Constant.Errors) {
		// Given
		sut.showAlert = false
		// When
		sut.showAlert(error: error)
		// Then
		XCTAssertTrue(sut.showAlert)
		XCTAssertEqual(sut.alertError, error)
		XCTAssertNotNil(sut.alertError?.errorDescription)
		XCTAssertNotNil(sut.alertError?.recoverySuggestion)
	}
}
