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
		sut.counterSelected.counter = Counter(count: 1,
											  date: .now)
		// When
		sut.decreaseCount()
		// Then
		XCTAssertEqual(sut.counterSelected.counter?.count, 0)
		XCTAssertEqual(sut.counterSelected.counter?.date.isDateToday, true)
	}

	/// Test increase counter count value
	func testIncreaseCount() {
		// Given
		sut.counterSelected.counter = Counter(count: 0,
											  date: .now)
		// When
		sut.increaseCount()
		// Then
		XCTAssertEqual(sut.counterSelected.counter?.count, 1)
		XCTAssertEqual(sut.counterSelected.counter?.date.isDateToday, true)
	}

	/// Test fetch counter
	func testFetchCounter() async {
		// Given
		sut.counterSelected.selectedDate = .now
		sut.counterSelected.counter = Counter(count: 0,
											  date: Calendar.current.date(byAdding: DateComponents(day: -1),
																		  to: .now) ?? .now)
		// When
		await sut.fetchCounter()
		// Then
		XCTAssertEqual(sut.counterSelected.counter?.date.isDateToday, true)
	}

	/// Test show alerts
	func testShowAlerts() {
		for error in Constants.Errors.allCases {
			testShowAlert(error: error)
		}
	}

	/// Test show alert helper
	private func testShowAlert(error: Constants.Errors) {
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
