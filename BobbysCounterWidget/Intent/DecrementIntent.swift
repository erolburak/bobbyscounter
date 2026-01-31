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
                throw Errors.decrement
            }
            try await Counter.fetch(
                categoryID: categoryID,
                date: .now
            )?.decrement()
            WidgetCenter.shared.reloadAllTimelines()
            return .result(dialog: "DecrementDialog")
        } catch {
            return .result(dialog: "DecrementDialogError")
        }
    }
}
