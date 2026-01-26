//
//  DecrementIntent.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 14.07.23.
//

import AppIntents
import WidgetKit

struct DecrementIntent: AppIntent {
    // MARK: - Properties

    static let description: IntentDescription = "DecrementDescription"
    static let title: LocalizedStringResource = "DecrementTitle"

    // MARK: - Methods

    func perform() async throws -> some IntentResult & ProvidesDialog {
        //        try await Counter.fetch(
        //            date: .now,
        //            category: ""
        //        )?.decrement()
        //        WidgetCenter.shared.reloadAllTimelines()
        return .result(dialog: "DecrementDialog")
    }
}
