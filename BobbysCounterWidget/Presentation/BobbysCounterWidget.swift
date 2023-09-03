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

	let kind = "BobbysCounterWidget"

	// MARK: - Layouts

	var body: some WidgetConfiguration {
		AppIntentConfiguration(kind: kind,
							   intent: CounterIntent.self,
							   provider: BobbysCounterWidgetProvider(fetchCounterUseCase: FetchCounterUseCase(),
																	 insertCounterUseCase: InsertCounterUseCase())) { entry in
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

	static var smallNumber: CounterIntent {
		let counter = CounterIntent()
		counter.count = 7
		counter.date = Date.now.toRelative
		return counter
	}

	static var largeNumber: CounterIntent {
		let counter = CounterIntent()
		counter.count = 7777
		counter.date = Date.now.toRelative
		return counter
	}

	static var extraLargeNumber: CounterIntent {
		let counter = CounterIntent()
		counter.count = 7777777777777777777
		counter.date = Date.now.toRelative
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
