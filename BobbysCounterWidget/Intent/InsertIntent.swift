//
//  InsertIntent.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 19.02.25.
//

import AppIntents
import WidgetKit

struct InsertIntent: AppIntent {
    // MARK: - Properties

    static let description: IntentDescription = "InsertDescription"
    static let title: LocalizedStringResource = "InsertTitle"

    // MARK: - Methods

    func perform() async throws -> some IntentResult & ProvidesDialog {
        try await Counter.insert(date: .now)
        WidgetCenter.shared.reloadAllTimelines()
        return .result(dialog: "InsertDialog")
    }
}
