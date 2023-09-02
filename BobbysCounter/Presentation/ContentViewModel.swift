//
//  ContentViewModel.swift
//  BobbysCounter
//
//  Created by Burak Erol on 13.07.23.
//

import Foundation

@Observable
class ContentViewModel {

	// MARK: - Use Cases

	private let decreaseCounterCountUseCase: PDecreaseCounterCountUseCase
	private let fetchCounterUseCase: PFetchCounterUseCase
	private let increaseCounterCountUseCase: PIncreaseCounterCountUseCase
	private let insertCounterUseCase: PInsertCounterUseCase

	// MARK: - Properties

	var alertError: Constants.Errors?
	var counterSelected = CounterSelected()
	var showAlert = false
	var showSettingsSheet = false

	// MARK: - Life Cycle

	init(decreaseCounterCountUseCase: PDecreaseCounterCountUseCase,
		 fetchCounterUseCase: PFetchCounterUseCase,
		 increaseCounterCountUseCase: PIncreaseCounterCountUseCase,
		 insertCounterUseCase: PInsertCounterUseCase) {
		self.decreaseCounterCountUseCase = decreaseCounterCountUseCase
		self.fetchCounterUseCase = fetchCounterUseCase
		self.increaseCounterCountUseCase = increaseCounterCountUseCase
		self.insertCounterUseCase = insertCounterUseCase
	}

	// MARK: - Actions

	/// Decrease counter count value
	func decreaseCounterCount() {
		decreaseCounterCountUseCase.decrease(counter: counterSelected.counter)
	}

	/// Increase counter count value
	func increaseCounterCount() {
		increaseCounterCountUseCase.increase(counter: counterSelected.counter)
	}

	/// Fetch counter matching selected date otherwise insert counter
	func fetchCounter() {
		guard let fetchedCounter = fetchCounterUseCase.fetch(selectedDate: counterSelected.selectedDate) else {
			counterSelected.counter = insertCounterUseCase.insert(selectedDate: counterSelected.selectedDate)
			return
		}
		counterSelected.counter = fetchedCounter
	}

	/// Set alert error and show alert
	func showAlert(error: Constants.Errors) {
		alertError = error
		showAlert = true
	}
}
