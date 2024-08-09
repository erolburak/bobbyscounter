//
//  IncreaseIntent.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 14.07.23.
//

import AppIntents
import SwiftData

struct IncreaseIntent: AppIntent {

	// MARK: - Properties

	static let title: LocalizedStringResource = "Increase"

	// MARK: - Actions

	func perform() async throws -> some IntentResult {
		let persistentIdentifier = try await CounterActor.shared.fetch(date: .now)
		let modelContext = ModelContext(CounterActor.shared.modelContainer)
		let counter = modelContext.model(for: persistentIdentifier) as? Counter
		try counter?.increase()
		try modelContext.save()
		return .result()
	}
}
