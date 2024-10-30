//
//  DecreaseIntent.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 14.07.23.
//

import AppIntents
import WidgetKit

struct DecreaseIntent: AppIntent {
    // MARK: - Properties

    static let description: IntentDescription = "DecreaseDescription"
    static let title: LocalizedStringResource = "DecreaseTitle"

    // MARK: - Methods

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        try await Counter.fetch(date: .now)?.decrease()
        WidgetCenter.shared.reloadAllTimelines()
        return .result(dialog: "DecreaseDialog")
    }
}
