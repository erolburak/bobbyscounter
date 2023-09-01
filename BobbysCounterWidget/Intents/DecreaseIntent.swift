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

	/// Fetch counter matching today and decrease counter count value if count greater than 0
	@MainActor
	func perform() throws -> some IntentResult {
		let counter = DataController.shared.fetchCounter(selectedDate: .now)
		if counter.count > 0 {
			counter.count -= 1
		}
		return .result()
	}
}
