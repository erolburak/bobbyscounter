//
//  SettingsViewModelTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 23.07.23.
//

@testable import BobbysCounter
import XCTest

class SettingsViewModelTests: XCTestCase {

	// MARK: - Private Properties

	private var sut: SettingsViewModel!

	// MARK: - Life Cycle

	override func setUpWithError() throws {
		sut = SettingsViewModel(counterSelected: CounterSelected(),
								deleteCounterUseCase: DeleteCounterUseCase(),
								fetchCounterUseCase: FetchCounterUseCase(),
								insertCounterUseCase: InsertCounterUseCase(),
								resetCountersUseCase: ResetCountersUseCase())
	}

	override func tearDownWithError() throws {
		sut = nil
	}

	// MARK: - Actions

	func testSettingsViewModelIsNotNil() {
		// Given
		let counterSelected = CounterSelected()
		// When
		let settingsViewModel = SettingsViewModel(counterSelected: counterSelected,
												  deleteCounterUseCase: DeleteCounterUseCase(),
												  fetchCounterUseCase: FetchCounterUseCase(),
									  insertCounterUseCase: InsertCounterUseCase(),
									  resetCountersUseCase: ResetCountersUseCase())
		// Then
		XCTAssertNotNil(settingsViewModel)
	}

	func testDelete() {
		// Given
		let counter = Counter(count: 1,
							  date: Calendar.current.date(byAdding: DateComponents(day: -1),
														  to: .now) ?? .now)
		sut.counterDelete = counter
		sut.counterSelected.counter = counter
		// When
		sut.delete()
		// Then
		XCTAssertNil(sut.counterDelete)
		XCTAssertTrue(sut.counterSelected.selectedDate.isDateToday)
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

	func testReset() async {
		// Given
		let date = Calendar.current.date(byAdding: DateComponents(day: -1),
										 to: .now) ?? .now
		sut.counterSelected.selectedDate = date
		// When
		sut.reset()
		// Then
		XCTAssertTrue(sut.counterSelected.selectedDate.isDateToday)
	}

	func testShowAnnotationIsTrue() {
		// Given
		sut.selectedPointMarkDate = .now
		// When
		let show = sut.showAnnotation(date: .now)
		// Then
		XCTAssertTrue(show)
	}

	func testShowAnnotationIsFalse() {
		// Given
		sut.selectedPointMarkDate = Calendar.current.date(byAdding: DateComponents(day: -1),
														  to: .now)
		// When
		let show = sut.showAnnotation(date: .now)
		// Then
		XCTAssertFalse(show)
	}

	func testShowAlerts() {
		for error in Constants.Errors.allCases {
			testShowAlertIsNotNil(error: error)
		}
	}

	private func testShowAlertIsNotNil(error: Constants.Errors) {
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

	func testChartXVisibleDomainLengthLowerBound() {
		// Given
		/// Calculate factor by multiplying 3 items with seconds, minutes and hours together
		/// 3 items is the lower bound of the range
		let length = 3 * 60 * 60 * 24
		let counters = Array(repeating: Counter(count: 1,
												date: .now),
							 count: 3)
		// When
		let newLength = sut.chartXVisibleDomainLength(counters: counters)
		// Then
		XCTAssertEqual(newLength, length)
	}

	func testChartXVisibleDomainLengthUpperBound() {
		// Given
		/// Calculate factor by multiplying 4 items with seconds, minutes and hours together
		/// 4 items is the upper bound of the range
		let length = 4 * 60 * 60 * 24
		let counters = Array(repeating: Counter(count: 1,
												date: .now),
							 count: 4)
		// When
		let newLength = sut.chartXVisibleDomainLength(counters: counters)
		// Then
		XCTAssertEqual(newLength, length)
	}

	func testSelectedPointMarkCounter() {
		// Given
		sut.selectedPointMarkDate = .now
		let counter = Counter(count: 0,
							  date: .now)
		let counters = [Counter(count: 1,
								date: Calendar.current.date(byAdding: DateComponents(day: -1),
															to: .now) ?? .now),
						counter]
		// When
		let newCounter = sut.selectedPointMarkCounter(counters: counters)
		// Then
		XCTAssertEqual(newCounter?.count, counter.count)
		XCTAssertEqual(newCounter?.date.isDateToday, counter.date.isDateToday)
	}
}
