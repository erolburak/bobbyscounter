//
//  DateExtensionTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 04.09.23.
//

import Foundation
import Testing

struct DateExtensionTests {

	// MARK: - Actions

	@Test("Check DateExtension isDateToday with now!")
	func testIsDateTodayWithNow() {
		// Given
		let date = Date.now
		// When
		let isDateToday = date.isDateToday
		// Then
		#expect(isDateToday,
				"DateExtension isDateToday with now failed!")
	}

	@Test("Check DateExtension isDateToday with tomorrow!")
	func testIsDateTodayWithTomorrow() {
		// Given
		let date = Calendar.current.date(byAdding: DateComponents(day: +1),
										 to: .now) ?? .now
		// When
		let isDateToday = date.isDateToday
		// Then
		#expect(isDateToday == false,
				"DateExtension isDateToday with tomorrow failed!")
	}

	@Test("Check DateExtension toDateWithoutTime!")
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
				"DateExtension toDateWithoutTime hour failed!")
		#expect(calendar.component(.minute,
								   from: dateWithoutTime ?? .now) == 0,
				"DateExtension toDateWithoutTime minute failed!")
		#expect(calendar.component(.second,
								   from: dateWithoutTime ?? .now) == 0,
				"DateExtension toDateWithoutTime second failed!")
		#expect(calendar.component(.nanosecond,
								   from: dateWithoutTime ?? .now) == 0,
				"DateExtension toDateWithoutTime nanosecond failed!")
	}

	@Test("Check DateExtension toRelative with now!")
	func testToRelativeWithNow() {
		// Given
		let date = Date.now
		let relative = "Today"
		// When
		let relativeDate = date.toRelative
		// Then
		#expect(relativeDate == relative,
				"DateExtension toRelative with now failed!")
	}

	@Test("Check DateExtension toRelative with yesterday!")
	func testToRelativeWithYesterday() {
		// Given
		let date = Calendar.current.date(byAdding: DateComponents(day: -1),
										 to: .now) ?? .now
		let relative = "Yesterday"
		// When
		let relativeDate = date.toRelative
		// Then
		#expect(relativeDate == relative,
				"DateExtension toRelative with yesterday failed!")
	}
}
