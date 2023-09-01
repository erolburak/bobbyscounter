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
	var counterSelectedModel: CounterSelectedModel = CounterSelectedModel()
	var showAlert: Bool = false
	var showSettingsSheet: Bool = false

	// MARK: - Actions

	/// Decrease counter count value if count greater than 0
	func decreaseCount() {
		DataController.shared.decreaseCount(counter: counterSelectedModel.counter)
	}

	/// Increase counter count value
	func increaseCount() {
		DataController.shared.increaseCount(counter: counterSelectedModel.counter)
	}

	/// Fetch counter matching selected date
	func fetchCounter() async {
		counterSelectedModel.counter = await DataController.shared.fetchCounter(selectedDate: counterSelectedModel.selectedDate)
	}

	/// Set alert error and show alert
	func showAlert(error: Constants.Errors) {
		alertError = error
		showAlert = true
	}
}
