//
//  BobbysCounterControlWidget.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 06.07.23.
//

import AppIntents
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
            BobbysCounterWidgetEntryView(
                categoryEntity: $0.categoryEntity,
                entry: $0
            )
            .containerBackground(
                .widgetBackground,
                for: .widget
            )
            .modelContainer(CategoryActor.shared.modelContainer)
        }
        // TODO: double check value and also rename
        .configurationDisplayName("WidgetConfigurationDisplayName")
        .description("WidgetDescription")
    }
}

//#Preview(
//    "System Small",
//    as: .systemSmall
//) {
//    BobbysCounterWidget()
//} timeline: {
//    BobbysCounterWidgetEntry()
//}
//
//#Preview(
//    "System Medium",
//    as: .systemMedium
//) {
//    BobbysCounterWidget()
//} timeline: {
//    BobbysCounterWidgetEntry()
//}
//
//#Preview(
//    "System Large",
//    as: .systemLarge
//) {
//    BobbysCounterWidget()
//} timeline: {
//    BobbysCounterWidgetEntry()
//}
//
//#Preview(
//    "System Extra Large",
//    as: .systemExtraLarge
//) {
//    BobbysCounterWidget()
//} timeline: {
//    BobbysCounterWidgetEntry()
//}
