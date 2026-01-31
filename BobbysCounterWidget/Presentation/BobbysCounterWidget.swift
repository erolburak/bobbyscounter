//
//  BobbysCounterControlWidget.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 06.07.23.
//

import SwiftUI
import WidgetKit

struct BobbysCounterWidget: Widget {
    // MARK: - Private Properties

    private let kind = "BobbysCounterWidget"

    // MARK: - Layouts

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: BobbysCounterWidgetConfigurationIntent.self,
            provider: BobbysCounterWidgetProvider()
        ) {
            BobbysCounterWidgetEntryView(entry: $0)
                .containerBackground(
                    .widgetBackground,
                    for: .widget
                )
        }
        .configurationDisplayName("WidgetConfigurationDisplayName")
        .description("WidgetDescription")
    }
}

#Preview(
    "System Small",
    as: .systemSmall
) {
    BobbysCounterWidget()
} timeline: {
    BobbysCounterWidgetEntry(categoryEntity: CategoryEntity.preview)
}

#Preview(
    "System Medium",
    as: .systemMedium
) {
    BobbysCounterWidget()
} timeline: {
    BobbysCounterWidgetEntry(categoryEntity: CategoryEntity.preview)
}

#Preview(
    "System Large",
    as: .systemLarge
) {
    BobbysCounterWidget()
} timeline: {
    BobbysCounterWidgetEntry(categoryEntity: CategoryEntity.preview)
}

#Preview(
    "System Extra Large",
    as: .systemExtraLarge
) {
    BobbysCounterWidget()
} timeline: {
    BobbysCounterWidgetEntry(categoryEntity: CategoryEntity.preview)
}
