//
//  Date+Extensions.swift
//  BobbysCounter
//
//  Created by Burak Erol on 17.07.23.
//

import Foundation

extension Date {

	// MARK: - Properties

	var isDateToday: Bool {
		Calendar.current.isDateInToday(self)
	}

	/// Formats date to string in a relative form -> `Yesterday`, `Today`, `Tomorrow`...
	var toRelative: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .none
		dateFormatter.doesRelativeDateFormatting = true
		return dateFormatter.string(from: self)
	}
}
