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

	static var title: LocalizedStringResource = "Increase"

	// MARK: - Actions

	@MainActor
	func perform() throws -> some IntentResult {
		try Counter.fetch(SharedModelContainer.shared.modelContainer.mainContext,
						  date: .now).increase()
		return .result()
	}
}
