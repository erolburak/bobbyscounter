//
//  SettingsViewModel.swift
//  BobbysCounter
//
//  Created by Burak Erol on 18.07.23.
//

import Foundation

@Observable
class SettingsViewModel {

	// MARK: - Properties

	var alertError: Constant.Errors?
	var chartScrollPosition: Date = .now
	var counterSelected: CounterSelected
	var selectedPointMarkDate: Date? = nil
	var showAlert: Bool = false
	var showConfirmationDialog: Bool = false

	// MARK: - Life Cycle

	init(counterSelected: CounterSelected) {
		self.counterSelected = counterSelected
	}

	// MARK: - Actions

	/// Fetch counter matching selected date
	func fetchCounter() async throws {
		counterSelected.counter = try await Repository.shared.fetchCounter(selectedDate: counterSelected.selectedDate)
	}

	/// Reset counters and reset view model properties
	func reset() async throws {
		do {
			try await Repository.shared.deleteCounters()
			alertError = nil
			chartScrollPosition = .now
			counterSelected.counter = Counter(count: 0,
											  date: .now)
			counterSelected.selectedDate = .now
			selectedPointMarkDate = nil
			showAlert = false
			showConfirmationDialog = false
		} catch Constant.Errors.reset {
			showAlert(error: .reset)
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
