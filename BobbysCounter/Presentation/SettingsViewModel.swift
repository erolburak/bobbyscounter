//
//  SettingsViewModel.swift
//  BobbysCounter
//
//  Created by Burak Erol on 18.07.23.
//

import SwiftUI

@Observable
class SettingsViewModel {

	// MARK: - Use Cases

	private let deleteCounterUseCase: PDeleteCounterUseCase
	private let fetchCounterUseCase: PFetchCounterUseCase
	private let insertCounterUseCase: PInsertCounterUseCase
	private let resetCountersUseCase: PResetCountersUseCase

	// MARK: - Properties

	var alertError: Constants.Errors?
	var chartScrollPosition = Date.now
	var counterDelete: Counter?
	var counterSelected: CounterSelected
	var selectedPointMarkDate: Date?
	var sensoryFeedback: SensoryFeedback = .success
	var sensoryFeedbackTrigger = false
	var showAlert = false
	var showCountersSheet = false
	var showDeleteConfirmationDialogPad = false
	var showDeleteConfirmationDialogPhone = false
	var showResetConfirmationDialogPad = false
	var showResetConfirmationDialogPhone = false

	// MARK: - Life Cycle

	init(counterSelected: CounterSelected,
		 deleteCounterUseCase: PDeleteCounterUseCase,
		 fetchCounterUseCase: PFetchCounterUseCase,
		 insertCounterUseCase: PInsertCounterUseCase,
		 resetCountersUseCase: PResetCountersUseCase) {
		self.counterSelected = counterSelected
		self.deleteCounterUseCase = deleteCounterUseCase
		self.fetchCounterUseCase = fetchCounterUseCase
		self.insertCounterUseCase = insertCounterUseCase
		self.resetCountersUseCase = resetCountersUseCase
	}

	// MARK: - Actions

	func delete() {
		if let counter = counterDelete {
			deleteCounterUseCase.delete(counter: counter)
			counterDelete = nil
			if counter == counterSelected.counter {
				counterSelected.selectedDate = .now
			}
			sensoryFeedback(feedback: .success)
		}
	}

	func fetchCounter() {
		guard let fetchedCounter = fetchCounterUseCase.fetch(selectedDate: counterSelected.selectedDate) else {
			counterSelected.counter = insertCounterUseCase.insert(selectedDate: counterSelected.selectedDate)
			return
		}
		counterSelected.counter = fetchedCounter
		sensoryFeedback(feedback: .selection)
	}

	func reset() {
		do {
			try resetCountersUseCase.reset()
			counterSelected.selectedDate = .now
			sensoryFeedback(feedback: .success)
		} catch Constants.Errors.reset {
			showAlert(error: .reset)
		} catch {
			showAlert(error: .error(error.localizedDescription))
		}
	}

	func showAlert(error: Constants.Errors) {
		alertError = error
		showAlert = true
		sensoryFeedback(feedback: .error)
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

	private func sensoryFeedback(feedback: SensoryFeedback) {
		sensoryFeedback = feedback
		DispatchQueue.main.async {
			self.sensoryFeedbackTrigger = true
		}
	}
}
