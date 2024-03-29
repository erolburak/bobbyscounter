//
//  IncreaseIntent.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 14.07.23.
//

import AppIntents

struct IncreaseIntent: AppIntent {

	// MARK: - Properties

	static let title: LocalizedStringResource = "Increase"

	// MARK: - Actions

	@MainActor
	func perform() async throws -> some IntentResult {
		try await CounterActor.shared.fetch(date: .now).increase()
		return .result()
	}
}
