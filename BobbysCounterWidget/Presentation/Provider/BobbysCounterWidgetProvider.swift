//
//  BobbysCounterWidgetProvider.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 18.07.23.
//

import WidgetKit

struct BobbysCounterWidgetProvider: AppIntentTimelineProvider {
    // MARK: - Methods

    func placeholder(in context: Context) -> BobbysCounterWidgetEntry {
        BobbysCounterWidgetEntry(
            categoryEntity: BobbysCounterWidgetConfigurationIntent().categoryEntity)
    }

    func snapshot(
        for configuration: BobbysCounterWidgetConfigurationIntent,
        in context: Context
    ) async -> BobbysCounterWidgetEntry {
        BobbysCounterWidgetEntry(categoryEntity: configuration.categoryEntity)
    }

    func timeline(
        for configuration: BobbysCounterWidgetConfigurationIntent,
        in context: Context
    ) async -> Timeline<BobbysCounterWidgetEntry> {
        Timeline(
            entries: [BobbysCounterWidgetEntry(categoryEntity: configuration.categoryEntity)],
            policy: .atEnd
        )
    }
}
