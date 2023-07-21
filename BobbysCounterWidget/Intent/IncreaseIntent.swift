//
//  IncreaseIntent.swift
//  BobbysCounter
//
//  Created by Burak Erol on 14.07.23.
//

import AppIntents
import SwiftData

struct IncreaseIntent: AppIntent {

	// MARK: - Properties

	static var title: LocalizedStringResource = "Increase"

	// MARK: - Actions

	/// Fetch todays counter and increase counter count value
	@MainActor
	func perform() async throws -> some IntentResult {
		guard let modelContainer = try? ModelContainer(for: [Counter.self]),
			  let counter = try Repository.shared.fetchTodaysCounter(modelContext: modelContainer.mainContext) else {
			return .result()
		}
		counter.count += 1
		return .result()
	}
}
