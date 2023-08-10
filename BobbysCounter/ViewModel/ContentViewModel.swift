//
//  ContentViewModel.swift
//  BobbysCounter
//
//  Created by Burak Erol on 13.07.23.
//

import Foundation

@Observable
class ContentViewModel {

	// MARK: - Properties

	var alertError: Constant.Errors?
	var counterSelected: CounterSelected
	var showAlert: Bool = false
	var showSettingsSheet: Bool = false

	// MARK: - Life Cycle

	init(counterSelected: CounterSelected) {
		self.counterSelected = counterSelected
	}

	// MARK: - Actions

	/// Decrease counter count value if count greater than 0
	func decreaseCount() {
		Repository.shared.decreaseCount(counter: counterSelected.counter)
	}

	/// Increase counter count value
	func increaseCount() {
		Repository.shared.increaseCount(counter: counterSelected.counter)
	}

	/// Fetch counter matching selected date
	func fetchCounter() async throws {
		do {
			counterSelected.counter = try await Repository.shared.fetchCounter(selectedDate: counterSelected.selectedDate)
		} catch Constant.Errors.fetch {
			showAlert(error: .fetch)
		} catch Constant.Errors.insert {
			showAlert(error: .insert)
		}
	}

	/// Set alert error and show alert
	func showAlert(error: Constant.Errors) {
		alertError = error
		showAlert = true
	}
}
