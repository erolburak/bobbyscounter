//
//  DateExtensionsTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 04.09.23.
//

@testable import BobbysCounter
import XCTest

class DateExtensionsTests: XCTestCase {

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
