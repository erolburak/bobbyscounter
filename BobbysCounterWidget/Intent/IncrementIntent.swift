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
    @Parameter(title: "Title")
    var title: String

    // MARK: - Lifecycle

    init() {}

    init(title: String) {
        self.title = title
    }

    // MARK: - Methods

    func perform() async throws -> some IntentResult & ProvidesDialog {
        do {
            guard let categoryID = try await Category.fetchID(title: title) else {
                throw Errors.increment
            }
            try await Counter.fetch(
                categoryID: categoryID,
                date: .now
            )?.increment()
            WidgetCenter.shared.reloadAllTimelines()
            return .result(dialog: "IncrementDialog")
        } catch {
            return .result(dialog: "IncrementDialogError")
        }
    }
}
