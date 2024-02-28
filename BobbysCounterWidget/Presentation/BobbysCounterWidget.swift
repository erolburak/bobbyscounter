//
//  BobbysCounterWidget.swift
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
		StaticConfiguration(kind: kind,
							provider: BobbysCounterWidgetProvider()) { entry in
			BobbysCounterWidgetEntryView(entry: entry)
				.containerBackground(.widgetBackground,
									 for: .widget)
				.modelContainer(CounterActor.shared.modelContainer)
		}
		.configurationDisplayName("WidgetConfigurationDisplayName")
		.description("WidgetDescription")
	}
}

#Preview("System Small",
		 as: .systemSmall) {
	BobbysCounterWidget()
} timeline: {
	BobbysCounterWidgetEntry()
}

#Preview("System Medium",
		 as: .systemMedium) {
	BobbysCounterWidget()
} timeline: {
	BobbysCounterWidgetEntry()
}

#Preview("System Large",
		 as: .systemLarge) {
	BobbysCounterWidget()
} timeline: {
	BobbysCounterWidgetEntry()
}

#Preview("System Extra Large",
		 as: .systemExtraLarge) {
	BobbysCounterWidget()
} timeline: {
	BobbysCounterWidgetEntry()
}
