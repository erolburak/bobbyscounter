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

    // MARK: - Methods

    @MainActor
    func perform() async throws -> some IntentResult {
        try await Counter.fetch(date: .now)?.increase()
        return .result()
    }
}
