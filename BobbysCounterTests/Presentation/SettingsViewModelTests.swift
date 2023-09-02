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
		sut = SettingsViewModel(counterSelected: CounterSelected(),
								fetchCounterUseCase: FetchCounterUseCase(),
								insertCounterUseCase: InsertCounterUseCase(),
								resetCountersUseCase: ResetCountersUseCase())
	}

	override func tearDownWithError() throws {
		sut = nil
	}

	/// Test fetch counter
	func testFetchCounter() {
		// Given
		sut.counterSelected.selectedDate = .now
		sut.counterSelected.counter = Counter(count: 0,
											  date: Calendar.current.date(byAdding: DateComponents(day: -1),
																		  to: .now) ?? .now)
		// When
		sut.fetchCounter()
		// Then
		XCTAssertEqual(sut.counterSelected.counter?.date.isDateToday, true)
	}

	/// Test reset
	func testReset() throws {
		// Given
		let date = Calendar.current.date(byAdding: DateComponents(day: -1),
										 to: .now) ?? .now
		sut.counterSelected.selectedDate = date
		sut.counterSelected.counter = Counter(count: 1,
											  date: date)
		// When
		try sut.reset()
		// Then
		XCTAssertEqual(sut.counterSelected.counter?.date.isDateToday, true)
		XCTAssertEqual(sut.counterSelected.counter?.count, 0)
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

	/// Test chart x visible domain length lower bound
	func testChartXVisibleDomainLengthLowerBound() {
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

	/// Test chart x visible domain length upper bound
	func testChartXVisibleDomainLengthUpperBound() {
		// Given
		/// Calculate factor by multiplying 4 items with seconds, minutes and hours together
		/// 4 items is the upper bound of the range
		let expected = 4 * 60 * 60 * 24
		let counters = Array(repeating: Counter(count: 1,
												date: .now),
							 count: 4)
		// When
		let length = sut.chartXVisibleDomainLength(counters: counters)
		// Then
		XCTAssertEqual(length, expected)
	}

	/// Test selected point mark counter
	func testSelectedPointMarkCounter() {
		// Given
		sut.selectedPointMarkDate = .now
		let expected = Counter(count: 0,
							   date: .now)
		let counters = [Counter(count: 1,
								date: Calendar.current.date(byAdding: DateComponents(day: -1),
															to: .now) ?? .now),
						expected]
		// When
		let counter = sut.selectedPointMarkCounter(counters: counters)
		// Then
		XCTAssertEqual(counter?.count, expected.count)
		XCTAssertEqual(counter?.date.isDateToday, expected.date.isDateToday)
	}
}
