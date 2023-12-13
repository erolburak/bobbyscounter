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

	static var title: LocalizedStringResource = "Decrease"

	// MARK: - Actions

	@MainActor
	func perform() throws -> some IntentResult {
		try Counter.fetch(SharedModelContainer.shared.modelContainer.mainContext,
						  date: .now).decrease()
		return .result()
	}
}
