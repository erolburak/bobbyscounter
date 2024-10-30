//
//  IncreaseIntent.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 14.07.23.
//

import AppIntents
import WidgetKit

struct IncreaseIntent: AppIntent {
    // MARK: - Properties

    static let description: IntentDescription = "IncreaseDescription"
    static let title: LocalizedStringResource = "IncreaseTitle"

    // MARK: - Methods

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        try await Counter.fetch(date: .now)?.increase()
        WidgetCenter.shared.reloadAllTimelines()
        return .result(dialog: "IncreaseDialog")
    }
}
