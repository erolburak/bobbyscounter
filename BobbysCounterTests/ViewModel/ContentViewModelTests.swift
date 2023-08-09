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

	/// Test fetch counter
	func testFetchCounter() async throws {
		// Given
		sut.counter = Counter(count: 0,
							  date: Calendar.current.date(byAdding: DateComponents(day: -1),
														  to: .now) ?? .now)
		sut.selectedDate = .now
		// When
		try await sut.fetchCounter()
		// Then
		XCTAssertEqual(sut.counter?.date.isDateToday, true)
	}

	/// Test show alert errors
	func testShowAlertErrors() {
		for error in Constant.Errors.allCases {
			testShowAlertError(error: error)
		}
	}

	/// Test show alert errors helper
	private func testShowAlertError(error: Constant.Errors) {
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
