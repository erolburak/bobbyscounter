//
//  IncrementIntent.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 14.07.23.
//

import AppIntents
import WidgetKit

struct IncrementIntent: AppIntent {
    // MARK: - Properties

    static let description: IntentDescription = "IncrementDescription"
    static let title: LocalizedStringResource = "IncrementTitle"

    // MARK: - Methods

    func perform() async throws -> some IntentResult & ProvidesDialog {
        //        try await Counter.fetch(
        //            date: .now,
        //            category: ""
        //        )?.increment()
        //        WidgetCenter.shared.reloadAllTimelines()
        return .result(dialog: "IncrementDialog")
    }
}
