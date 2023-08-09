//
//  SettingsViewModel.swift
//  BobbysCounter
//
//  Created by Burak Erol on 18.07.23.
//

import SwiftData
import SwiftUI

@Observable
class SettingsViewModel {

	// MARK: - Properties

	var alertError: Constant.Errors?
	var chartScrollPosition: Date = .now
	var selectedPointMarkDate: Date? = nil
	var showAlert: Bool = false
	var showConfirmationDialog: Bool = false

	// MARK: - Actions

	/// Fetch counter matching selected date
	func fetchCounter(selectedDate: Date) async throws -> Counter? {
		do {
			return try await Repository.shared.fetchCounter(selectedDate: selectedDate)
		} catch Constant.Errors.insert {
			showAlert(error: .insert)
			return nil
		}
	}

	/// Reset counters, reset view model properties, set counter and return object
	func reset(selectedDate: Date) async throws -> Counter? {
		do {
			try await Repository.shared.deleteCounters()
			alertError = nil
			showAlert = false
			showConfirmationDialog = false
			return try await fetchCounter(selectedDate: selectedDate)
		} catch Constant.Errors.reset {
			showAlert(error: .reset)
			return nil
		}
	}

	/// Set alert error and show alert
	func showAlert(error: Constant.Errors) {
		alertError = error
		showAlert = true
	}

	/// Show annotation if date matching selected point mark date
	func showAnnotation(date: Date) -> Bool {
		date.formatted(date: .complete,
					   time: .omitted) == selectedPointMarkDate?.formatted(date: .complete,
																		   time: .omitted)
	}

	// MARK: - Helper

	/// Calculate and return length for chart x visible domain
	func chartXVisibleDomainLength(counters: [Counter]) -> Int {
		/// Calculate factor by multiplying seconds, minutes and hours together
		let factor = 60 * 60 * 24
		let count = counters.count
		let range = 3...4
		return range.contains(count) ? count * factor : range.upperBound * factor
	}

	/// Return counter matching  selected point mark date otherwise return nil
	func selectedPointMarkCounter(counters: [Counter]) -> Counter? {
		counters.first { Calendar.current.isDate($0.date,
												 inSameDayAs: selectedPointMarkDate ?? .now) }
	}
}
