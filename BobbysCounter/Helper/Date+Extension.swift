//
//  Date+Extension.swift
//  BobbysCounter
//
//  Created by Burak Erol on 17.07.23.
//

import Foundation

extension Date {

	// MARK: - Properties

	var isDateToday: Bool {
		var calendar = Calendar.current
		calendar.timeZone = .current
		return calendar.isDateInToday(self)
	}

	/// Formats date to date without time
	var toDateWithoutTime: Date? {
		var calendar = Calendar.current
		calendar.timeZone = .current
		let dateComponents = calendar.dateComponents([.year,
													  .month,
													  .day],
													 from: self)
		return calendar.date(from: dateComponents)
	}

	/// Formats date to string in a relative form -> `Yesterday`, `Today`, `Tomorrow`...
	var toRelative: String {
		let dateFormatter = DateFormatter()
		dateFormatter.calendar = .current
		dateFormatter.timeZone = .current
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .none
		dateFormatter.doesRelativeDateFormatting = true
		return dateFormatter.string(from: self)
	}
}
