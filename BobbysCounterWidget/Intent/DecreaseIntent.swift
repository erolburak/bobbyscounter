//
//  DecreaseIntent.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 14.07.23.
//

import AppIntents

struct DecreaseIntent: AppIntent {
    // MARK: - Properties

    static let title: LocalizedStringResource = "Decrease"

    // MARK: - Methods

    @MainActor
    func perform() async throws -> some IntentResult {
        try await Counter.fetch(date: .now)?.decrease()
        return .result()
    }
}
