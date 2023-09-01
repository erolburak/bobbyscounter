//
//  BobbysCounterWidget.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 06.07.23.
//

import SwiftUI
import WidgetKit

struct BobbysCounterWidget: Widget {

	// MARK: - Properties

	let kind: String = "BobbysCounterWidget"

	// MARK: - Layouts

	var body: some WidgetConfiguration {
		AppIntentConfiguration(kind: kind,
							   intent: CounterIntent.self,
							   provider: BobbysCounterWidgetProvider()) { entry in
			BobbysCounterWidgetEntryView(entry: entry)
				.containerBackground(.widgetBackground,
									 for: .widget)
		}
		.configurationDisplayName("AppName")
		.description("WidgetDescription")
	}
}

fileprivate extension CounterIntent {

	// MARK: - Properties

	/// Create CounterIntent with small number for preview
	static var smallNumber: CounterIntent {
		let counter = CounterIntent()
		counter.count = 7
		counter.date = Date.now.relative
		return counter
	}

	/// Create CounterIntent with large number for preview
	static var largeNumber: CounterIntent {
		let counter = CounterIntent()
		counter.count = 7777
		counter.date = Date.now.relative
		return counter
	}

	/// Create CounterIntent with extra large number for preview
	static var extraLargeNumber: CounterIntent {
		let counter = CounterIntent()
		counter.count = 7777777777777777777
		counter.date = Date.now.relative
		return counter
	}
}

#Preview("System Small",
		 as: .systemSmall) {
	BobbysCounterWidget()
} timeline: {
	BobbysCounterWidgetEntry(counterIntent: .smallNumber)
	BobbysCounterWidgetEntry(counterIntent: .largeNumber)
	BobbysCounterWidgetEntry(counterIntent: .extraLargeNumber)
}

#Preview("System Extra Large",
		 as: .systemExtraLarge) {
	BobbysCounterWidget()
} timeline: {
	BobbysCounterWidgetEntry(counterIntent: .smallNumber)
	BobbysCounterWidgetEntry(counterIntent: .largeNumber)
	BobbysCounterWidgetEntry(counterIntent: .extraLargeNumber)
}
