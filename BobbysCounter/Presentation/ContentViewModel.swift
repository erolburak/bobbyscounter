//
//  ContentViewModel.swift
//  BobbysCounter
//
//  Created by Burak Erol on 13.07.23.
//

import SwiftUI

@Observable
class ContentViewModel {

	// MARK: - Use Cases

	private let decreaseCounterCountUseCase: PDecreaseCounterCountUseCase
	private let fetchCounterUseCase: PFetchCounterUseCase
	private let increaseCounterCountUseCase: PIncreaseCounterCountUseCase
	private let insertCounterUseCase: PInsertCounterUseCase

	// MARK: - Properties

	var counterSelected = CounterSelected()
	var sensoryFeedback: SensoryFeedback = .decrease
	var sensoryFeedbackTrigger = false
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

	func decreaseCounterCount() {
		decreaseCounterCountUseCase.decrease(counter: counterSelected.counter)
		guard let count = counterSelected.counter?.count,
			  count > 0 else { return }
		sensoryFeedback(feedback: .decrease)
	}

	func increaseCounterCount() {
		increaseCounterCountUseCase.increase(counter: counterSelected.counter)
		sensoryFeedback(feedback: .increase)
	}

	func fetchCounter() {
		guard let fetchedCounter = fetchCounterUseCase.fetch(selectedDate: counterSelected.selectedDate) else {
			counterSelected.counter = insertCounterUseCase.insert(selectedDate: counterSelected.selectedDate)
			return
		}
		counterSelected.counter = fetchedCounter
	}

	private func sensoryFeedback(feedback: SensoryFeedback) {
		sensoryFeedback = feedback
		DispatchQueue.main.async {
			self.sensoryFeedbackTrigger = true
		}
	}
}
