//
//  IncreaseIntent.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 14.07.23.
//

import AppIntents
import SwiftData

struct IncreaseIntent: AppIntent {

	// MARK: - Use Cases

	private let fetchCounterUseCase: PFetchCounterUseCase
	private let increaseCounterCountUseCase: PIncreaseCounterCountUseCase

	// MARK: - Properties

	static var title: LocalizedStringResource = "Increase"

	// MARK: - Life Cycle

	init() {
		self.fetchCounterUseCase = FetchCounterUseCase()
		self.increaseCounterCountUseCase = IncreaseCounterCountUseCase()
	}

	// MARK: - Actions

	@MainActor
	func perform() throws -> some IntentResult {
		let counter = fetchCounterUseCase.fetch(selectedDate: .now)
		increaseCounterCountUseCase.increase(counter: counter)
		return .result()
	}
}
