//
//  DateExtensionTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 04.09.23.
//

@testable import BobbysCounter
import Foundation
import Testing

struct DateExtensionTests {

	// MARK: - Actions

	@Test("Check is date today formatter with now!")
	func testIsDateTodayIsTrue() {
		// Given
		let date = Date.now
		// When
		let isDateToday = date.isDateToday
		// Then
		#expect(isDateToday,
				"Date to is date today formatter with now failed!")
	}

	@Test("Check is date today formatter with tomorrow!")
	func testIsDateTodayIsFalse() {
		// Given
		let date = Calendar.current.date(byAdding: DateComponents(day: +1),
										 to: .now) ?? .now
		// When
		let isDateToday = date.isDateToday
		// Then
		#expect(isDateToday == false,
				"Date to is date today formatter with tomorrow failed!")
	}

	@Test("Check date to date without time formatter with today!")
	func testToDateWithoutTime() {
		// Given
		var calendar = Calendar.current
		calendar.timeZone = .current
		let date = Date.now
		// When
		let dateWithoutTime = date.toDateWithoutTime
		// Then
		#expect(calendar.component(.hour,
								   from: dateWithoutTime ?? .now) == 0,
				"Date to date without time formatter with hour failed!")
		#expect(calendar.component(.minute,
								   from: dateWithoutTime ?? .now) == 0,
				"Date to date without time formatter with minute failed!")
		#expect(calendar.component(.second,
								   from: dateWithoutTime ?? .now) == 0,
				"Date to date without time formatter with second failed!")
		#expect(calendar.component(.nanosecond,
								   from: dateWithoutTime ?? .now) == 0,
				"Date to date without time formatter with nanosecond failed!")
	}

	@Test("Check date to relative formatter with today!")
	func testToRelativeIsToday() {
		// Given
		let date = Date.now
		let relative = "Today"
		// When
		let relativeDate = date.toRelative
		// Then
		#expect(relativeDate == relative,
				"Date to relative formatter with today failed!")
	}

	@Test("Check date to relative formatter with yesterday!")
	func testToRelativeIsYesterday() {
		// Given
		let date = Calendar.current.date(byAdding: DateComponents(day: -1),
										 to: .now) ?? .now
		let relative = "Yesterday"
		// When
		let relativeDate = date.toRelative
		// Then
		#expect(relativeDate == relative,
				"Date to relative formatter with yesterday failed!")
	}
}
