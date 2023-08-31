//
//  BobbysCounterWidgetProvider.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 18.07.23.
//

import WidgetKit

struct BobbysCounterWidgetProvider: AppIntentTimelineProvider {

	@MainActor
	func placeholder(in context: Context) -> BobbysCounterWidgetEntry {
		BobbysCounterWidgetEntry(counterIntent: setCounterIntent(for: nil))
	}

	func snapshot(for configuration: CounterIntent,
				  in context: Context) async -> BobbysCounterWidgetEntry {
		await BobbysCounterWidgetEntry(counterIntent: setCounterIntent(for: configuration))
	}

	func timeline(for configuration: CounterIntent,
				  in context: Context) async -> Timeline<BobbysCounterWidgetEntry> {
		await Timeline(entries: [BobbysCounterWidgetEntry(counterIntent: setCounterIntent(for: configuration))],
					   policy: .atEnd)
	}

	/// Set counter intent for configuration after todays counter is fetched
	@MainActor
	private func setCounterIntent(for configuration: CounterIntent?) -> CounterIntent {
		guard let configuration,
			  let counter = fetchCounter() else {
			return CounterIntent()
		}
		configuration.count = counter.count
		configuration.date = counter.date.relative
		return configuration
	}

	/// Fetch counter where date is matching today and return object otherwise return nil
	@MainActor
	private func fetchCounter() -> Counter? {
		Repository.shared.fetchCounter(selectedDate: .now)
	}
}
