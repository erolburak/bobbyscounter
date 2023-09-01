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

	var alertError: Constants.Errors?
	var counterSelected: CounterSelected = CounterSelected()
	var showAlert: Bool = false
	var showSettingsSheet: Bool = false

	// MARK: - Actions

	/// Decrease counter count value if count greater than 0
	func decreaseCount() {
		DataController.shared.decreaseCount(counter: counterSelected.counter)
	}

	/// Increase counter count value
	func increaseCount() {
		DataController.shared.increaseCount(counter: counterSelected.counter)
	}

	/// Fetch counter matching selected date
	func fetchCounter() async {
		counterSelected.counter = await DataController.shared.fetchCounter(selectedDate: counterSelected.selectedDate)
	}

	/// Set alert error and show alert
	func showAlert(error: Constants.Errors) {
		alertError = error
		showAlert = true
	}
}
