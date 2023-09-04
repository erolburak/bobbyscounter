//
//  SettingsViewModel.swift
//  BobbysCounter
//
//  Created by Burak Erol on 18.07.23.
//

import Foundation

@Observable
class SettingsViewModel {

	// MARK: - Use Cases

	private let fetchCounterUseCase: PFetchCounterUseCase
	private let insertCounterUseCase: PInsertCounterUseCase
	private let resetCountersUseCase: PResetCountersUseCase

	// MARK: - Properties

	var alertError: Constants.Errors?
	var chartScrollPosition = Date.now
	var counterSelected: CounterSelected
	var selectedPointMarkDate: Date?
	var showAlert = false
	var showConfirmationDialog = false

	// MARK: - Life Cycle

	init(counterSelected: CounterSelected,
		 fetchCounterUseCase: PFetchCounterUseCase,
		 insertCounterUseCase: PInsertCounterUseCase,
		 resetCountersUseCase: PResetCountersUseCase) {
		self.counterSelected = counterSelected
		self.fetchCounterUseCase = fetchCounterUseCase
		self.insertCounterUseCase = insertCounterUseCase
		self.resetCountersUseCase = resetCountersUseCase
	}

	// MARK: - Actions

	func fetchCounter() {
		guard let fetchedCounter = fetchCounterUseCase.fetch(selectedDate: counterSelected.selectedDate) else {
			counterSelected.counter = insertCounterUseCase.insert(selectedDate: counterSelected.selectedDate)
			return
		}
		counterSelected.counter = fetchedCounter
	}

	func reset() throws {
		do {
			try resetCountersUseCase.reset()
			counterSelected.selectedDate = .now
			fetchCounter()
		} catch Constants.Errors.reset {
			showAlert(error: .reset)
		}
	}

	func showAlert(error: Constants.Errors) {
		alertError = error
		showAlert = true
	}

	func showAnnotation(date: Date) -> Bool {
		date.formatted(date: .complete,
					   time: .omitted) == selectedPointMarkDate?.formatted(date: .complete,
																		   time: .omitted)
	}

	func chartXVisibleDomainLength(counters: [Counter]) -> Int {
		/// Calculate factor by multiplying seconds, minutes and hours together
		let factor = 60 * 60 * 24
		let count = counters.count
		let range = 3...4
		return range.contains(count) ? count * factor : range.upperBound * factor
	}

	func selectedPointMarkCounter(counters: [Counter]) -> Counter? {
		counters.first { Calendar.current.isDate($0.date,
												 inSameDayAs: selectedPointMarkDate ?? .now) }
	}
}
