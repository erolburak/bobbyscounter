//
//  DateExtensionsTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 04.09.23.
//

@testable import BobbysCounter
import XCTest

class DateExtensionsTests: XCTestCase {

	// MARK: - Actions

	func testIsDateTodayIsTrue() {
		// Given
		let date = Date.now
		// When
		let isDateToday = date.isDateToday
		// Then
		XCTAssertTrue(isDateToday)
	}

	func testIsDateTodayIsFalse() {
		// Given
		let date = Calendar.current.date(byAdding: DateComponents(day: +1),
										 to: .now)
		// When
		let isDateToday = date?.isDateToday ?? true
		// Then
		XCTAssertFalse(isDateToday)
	}

	func testToDateWithoutTime() {
		// Given
		var calendar = Calendar.current
		calendar.timeZone = .current
		let date = Date.now
		// When
		let dateWithoutTime = date.toDateWithoutTime
		// Then
		XCTAssertEqual(0, calendar.component(.hour,
											 from: dateWithoutTime ?? .now))
		XCTAssertEqual(0, calendar.component(.minute,
											 from: dateWithoutTime ?? .now))
		XCTAssertEqual(0, calendar.component(.second,
											 from: dateWithoutTime ?? .now))
		XCTAssertEqual(0, calendar.component(.nanosecond,
											 from: dateWithoutTime ?? .now))
	}

	func testToRelativeIsToday() {
		// Given
		let date = Date.now
		let relative = Locale.current.language.languageCode == "en" ? "Today" : ""
		// When
		let relativeDate = date.toRelative
		// Then
		XCTAssertEqual(relativeDate, relative)
	}

	func testToRelativeIsYesterday() {
		// Given
		let date = Calendar.current.date(byAdding: DateComponents(day: -1),
										 to: .now)
		let relative = Locale.current.language.languageCode == "en" ? "Yesterday" : ""
		// When
		let relativeDate = date?.toRelative ?? relative
		// Then
		XCTAssertEqual(relativeDate, relative)
	}
}
