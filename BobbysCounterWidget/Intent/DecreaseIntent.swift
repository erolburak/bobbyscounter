//
//  DecreaseIntent.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 14.07.23.
//

import AppIntents
import SwiftData

struct DecreaseIntent: AppIntent {

	// MARK: - Properties

	static let title: LocalizedStringResource = "Decrease"

	// MARK: - Actions

	func perform() async throws -> some IntentResult {
		let persistentIdentifier = try await CounterActor.shared.fetch(date: .now)
		let modelContext = ModelContext(CounterActor.shared.modelContainer)
		let counter = modelContext.model(for: persistentIdentifier) as? Counter
		try counter?.decrease()
		try modelContext.save()
		return .result()
	}
}
