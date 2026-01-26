//
//  BobbysCounterWidgetConfigurationIntent.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 26.01.26.
//

import AppIntents
import SwiftData

struct BobbysCounterWidgetConfigurationIntent: WidgetConfigurationIntent {
    // MARK: - Properties

    static let description: IntentDescription = "BobbysCounterWidgetConfigurationIntentDescription"
    static let title: LocalizedStringResource = "BobbysCounterWidgetConfigurationIntentTitle"

    @Parameter(title: "Category")
    var categoryEntity: CategoryEntity?
}
