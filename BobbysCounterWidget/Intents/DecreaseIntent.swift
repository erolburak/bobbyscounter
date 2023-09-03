//
//  DecreaseIntent.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 14.07.23.
//

import AppIntents
import SwiftData

struct DecreaseIntent: AppIntent {

	// MARK: - Use Cases

	private let decreaseCounterCountUseCase: PDecreaseCounterCountUseCase
	private let fetchCounterUseCase: PFetchCounterUseCase

	// MARK: - Properties

	static var title: LocalizedStringResource = "Decrease"

	// MARK: - Life Cycle

	init() {
		self.decreaseCounterCountUseCase = DecreaseCounterCountUseCase()
		self.fetchCounterUseCase = FetchCounterUseCase()
	}

	// MARK: - Actions

	@MainActor
	func perform() throws -> some IntentResult {
		let counter = fetchCounterUseCase.fetch(selectedDate: .now)
		decreaseCounterCountUseCase.decrease(counter: counter)
		return .result()
	}
}
