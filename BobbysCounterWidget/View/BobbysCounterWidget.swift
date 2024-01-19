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
		}
		.configurationDisplayName("WidgetConfigurationDisplayName")
		.description("WidgetDescription")
	}
}

extension BobbysCounterWidget {

	// MARK: - Properties

	static var smallNumberEntry: BobbysCounterWidgetEntry {
		BobbysCounterWidgetEntry(counter: Counter(count: 7,
												  date: .now))
	}

	static var largeNumberEntry: BobbysCounterWidgetEntry {
		BobbysCounterWidgetEntry(counter: Counter(count: 7777,
												  date: .now))
	}

	static var extraLargeNumberEntry: BobbysCounterWidgetEntry {
		BobbysCounterWidgetEntry(counter: Counter(count: 7777777777777777777,
												  date: .now))
	}
}

#Preview("System Small",
		 as: .systemSmall) {
	BobbysCounterWidget()
} timeline: {
	BobbysCounterWidget.smallNumberEntry
	BobbysCounterWidget.largeNumberEntry
	BobbysCounterWidget.extraLargeNumberEntry
}

#Preview("System Medium",
		 as: .systemMedium) {
	BobbysCounterWidget()
} timeline: {
	BobbysCounterWidget.smallNumberEntry
	BobbysCounterWidget.largeNumberEntry
	BobbysCounterWidget.extraLargeNumberEntry
}

#Preview("System Large",
		 as: .systemLarge) {
	BobbysCounterWidget()
} timeline: {
	BobbysCounterWidget.smallNumberEntry
	BobbysCounterWidget.largeNumberEntry
	BobbysCounterWidget.extraLargeNumberEntry
}

#Preview("System Extra Large",
		 as: .systemExtraLarge) {
	BobbysCounterWidget()
} timeline: {
	BobbysCounterWidget.smallNumberEntry
	BobbysCounterWidget.largeNumberEntry
	BobbysCounterWidget.extraLargeNumberEntry
}
