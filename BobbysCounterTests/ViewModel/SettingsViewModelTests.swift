//
//  SettingsViewModelTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 23.07.23.
//

@testable import BobbysCounter
import XCTest

class SettingsViewModelTests: XCTestCase {

	private var sut: SettingsViewModel!

	override func setUpWithError() throws {
		sut = SettingsViewModel()
	}

	override func tearDownWithError() throws {
		sut = nil
	}

	/// Test fetch counter
	func testFetchCounter() async throws {
		// Given
		let expected = Counter(count: 0,
							   date: .now)
		// When
		let counter = try await sut.fetchCounter(selectedDate: .now)
		// Then
		XCTAssertEqual(counter?.date.isDateToday, expected.date.isDateToday)
	}

	/// Test reset
	func testReset() async throws {
		// Given
		let expected = Counter(count: 0,
							   date: .now)
		sut.alertError = .fetch
		sut.showAlert = true
		sut.showConfirmationDialog = true
		// When
		let counter = try await sut.reset(selectedDate: .now)
		// Then
		XCTAssertEqual(sut.alertError, nil)
		XCTAssertEqual(sut.showAlert, false)
		XCTAssertEqual(sut.showConfirmationDialog, false)
		XCTAssertEqual(counter?.count, expected.count)
		XCTAssertEqual(counter?.date.isDateToday, expected.date.isDateToday)
	}

	/// Test show annotation is true
	func testShowAnnotationIsTrue() {
		// Given
		sut.selectedPointMarkDate = .now
		// When
		let show = sut.showAnnotation(date: .now)
		// Then
		XCTAssertEqual(show, true)
	}

	/// Test show annotation is false
	func testShowAnnotationIsFalse() {
		// Given
		sut.selectedPointMarkDate = Calendar.current.date(byAdding: DateComponents(day: -1),
														  to: .now)
		// When
		let show = sut.showAnnotation(date: .now)
		// Then
		XCTAssertEqual(show, false)
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

	/// Test chart x visible domain length in range
	func testChartXVisibleDomainLengthInRange() {
		// Given
		/// Calculate factor by multiplying 3 items with seconds, minutes and hours together
		/// 3 items is the lower bound of the range
		let expected = 3 * 60 * 60 * 24
		let counters = Array(repeating: Counter(count: 1,
												date: .now),
							 count: 3)
		// When
		let length = sut.chartXVisibleDomainLength(counters: counters)
		// Then
		XCTAssertEqual(length, expected)
	}

	/// Test chart x visible domain length out of range
	func testChartXVisibleDomainLengthOutOfRange() {
		// Given
		/// Calculate factor by multiplying 4 items with seconds, minutes and hours together
		/// 4 items is the upper bound of the range
		let expected = 4 * 60 * 60 * 24
		let counters = Array(repeating: Counter(count: 1,
												date: .now),
							 count: 7)
		// When
		let length = sut.chartXVisibleDomainLength(counters: counters)
		// Then
		XCTAssertEqual(length, expected)
	}

	/// Test selected point mark counter
	func testSelectedPointMarkCounter() {
		// Given
		let date = Calendar.current.date(byAdding: DateComponents(day: -5),
										 to: .now)
		sut.selectedPointMarkDate = date
		let expected = Counter(count: 7,
							   date: date ?? .now)
		let counters = [expected,
						Counter(count: 1,
								date: Calendar.current.date(byAdding: DateComponents(day: -1),
															to: .now) ?? .now),
						Counter(count: 2,
								date: Calendar.current.date(byAdding: DateComponents(day: 1),
															to: .now) ?? .now)]
		// When
		let counter = sut.selectedPointMarkCounter(counters: counters)
		// Then
		XCTAssertEqual(counter, expected)
	}
}
