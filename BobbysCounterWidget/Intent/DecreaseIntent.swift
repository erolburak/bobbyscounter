//
//  DecreaseIntent.swift
//  BobbysCounter
//
//  Created by Burak Erol on 14.07.23.
//

import AppIntents
import SwiftData

struct DecreaseIntent: AppIntent {

	// MARK: - Properties

	static var title: LocalizedStringResource = "Decrease"

	// MARK: - Actions

	/// Fetch todays counter and decrease counter count value if count greater than 0
	@MainActor
	func perform() async throws -> some IntentResult {
		guard let counter = try Repository.shared.fetchTodaysCounter(),
			  counter.count > 0 else {
			return .result()
		}
		counter.count -= 1
		return .result()
	}
}
