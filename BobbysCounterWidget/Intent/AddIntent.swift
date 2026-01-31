//
//  AddIntent.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 19.02.25.
//

import AppIntents
import WidgetKit

struct AddIntent: AppIntent {
    // MARK: - Properties

    static let description: IntentDescription = "AddDescription"
    static let title: LocalizedStringResource = "AddTitle"
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
                throw Errors.addCounter
            }
            try await Counter.add(
                categoryID: categoryID,
                date: .now
            )
            WidgetCenter.shared.reloadAllTimelines()
            return .result(dialog: "AddDialog")
        } catch {
            return .result(dialog: "AddDialogError")
        }
    }
}
