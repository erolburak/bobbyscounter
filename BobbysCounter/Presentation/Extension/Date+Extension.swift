//
//  Date+Extension.swift
//  BobbysCounter
//
//  Created by Burak Erol on 17.07.23.
//

import Foundation

extension Date {

	// MARK: - Private Properties

	private static let calendar = {
		var calendar = Calendar.current
		calendar.timeZone = .current
		return calendar
	}()

	private static let relativeDateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.calendar = calendar
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .none
		dateFormatter.doesRelativeDateFormatting = true
		return dateFormatter
	}()

	// MARK: - Properties

	var isDateToday: Bool {
		Date.calendar.isDateInToday(self)
	}

	/// Formats date to date without time
	var toDateWithoutTime: Date? {
		let dateComponents = Date.calendar.dateComponents([.day,
														   .month,
														   .year],
														  from: self)
		return Date.calendar.date(from: dateComponents)
	}

	/// Formats date to string in a relative form -> `Yesterday`, `Today`, `Tomorrow`...
	var toRelative: String {
		Date.relativeDateFormatter.string(from: self)
	}
}
