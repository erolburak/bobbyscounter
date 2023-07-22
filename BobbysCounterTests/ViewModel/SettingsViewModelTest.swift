//
//  SettingsViewModelTest.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 23.07.23.
//

@testable import BobbysCounter
import XCTest

class SettingsViewModelTest: XCTestCase {

	var sut: SettingsViewModel!

	override func setUpWithError() throws {
		sut = SettingsViewModel()
	}

	override func tearDownWithError() throws {
		sut = nil
	}

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

	func testSetCounter() async throws {
		// Given
		let expected = Counter(count: 0,
							   date: .now)
		let counters = [expected,
						Counter(count: 1,
								date: Calendar.current.date(byAdding: DateComponents(day: -1),
															to: .now) ?? .now),
						Counter(count: 2,
								date: Calendar.current.date(byAdding: DateComponents(day: 1),
															to: .now) ?? .now)]

		// When
		let counter = try await sut.setCounter(counters: counters,
											   selectedDate: .now)

		// Then
		XCTAssertEqual(counter?.count, expected.count)
		XCTAssertEqual(counter?.date.isDateToday, expected.date.isDateToday)
	}
}
