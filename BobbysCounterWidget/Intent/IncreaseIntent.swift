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

	/// Fetch counter matching today and increase counter count value
	@MainActor
	func perform() throws -> some IntentResult {
		let counter = try Repository.shared.fetchCounter(selectedDate: .now)
		counter.count += 1
		return .result()
	}
}
