//
//  DecreaseIntent.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 14.07.23.
//

import AppIntents

struct DecreaseIntent: AppIntent {

	// MARK: - Use Cases

//	private let decreaseCounterCountUseCase: PDecreaseCounterCountUseCase
//	private let fetchCounterUseCase: PFetchCounterUseCase

	// MARK: - Properties

	static var title: LocalizedStringResource = "Decrease"

	// MARK: - Life Cycle

	init() {
//		self.decreaseCounterCountUseCase = DecreaseCounterCountUseCase()
//		self.fetchCounterUseCase = FetchCounterUseCase()
	}

	// MARK: - Actions

	func perform() -> some IntentResult {
//		let counter = fetchCounterUseCase.fetch(selectedDate: .now)
//		decreaseCounterCountUseCase.decrease(counter: counter)
		return .result()
	}
}
