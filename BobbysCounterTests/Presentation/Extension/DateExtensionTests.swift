//
//  DateExtensionTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 04.09.23.
//

import Foundation
import Testing

@Suite("DateExtension tests")
struct DateExtensionTests {
    // MARK: - Methods

    @Test("Check DateExtension isDateToday with now!")
    func isDateTodayWithNow() {
        // Given
        let date = Date.now
        // When
        let isDateToday = date.isDateToday
        // Then
        #expect(isDateToday,
                "DateExtension isDateToday with now failed!")
    }

    @Test("Check DateExtension isDateToday with tomorrow!")
    func isDateTodayWithTomorrow() {
        // Given
        let date = Calendar.current.date(byAdding: DateComponents(day: +1),
                                         to: .now) ?? .now
        // When
        let isDateToday = date.isDateToday
        // Then
        #expect(!isDateToday,
                "DateExtension isDateToday with tomorrow failed!")
    }

    @Test("Check DateExtension toDateWithoutTime!")
    func toDateWithoutTime() {
        // Given
        var calendar = Calendar.current
        calendar.timeZone = .current
        let date = Date.now
        // When
        let dateWithoutTime = date.toDateWithoutTime
        // Then
        #expect(calendar.component(.hour,
                                   from: dateWithoutTime ?? .now) == .zero &&
                calendar.component(.minute,
                                   from: dateWithoutTime ?? .now) == .zero &&
                calendar.component(.second,
                                   from: dateWithoutTime ?? .now) == .zero &&
                calendar.component(.nanosecond,
                                   from: dateWithoutTime ?? .now) == .zero,
            "DateExtension toDateWithoutTime failed!")
    }

    @Test("Check DateExtension toRelative with now!")
    func toRelativeWithNow() {
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
    func toRelativeWithYesterday() {
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
