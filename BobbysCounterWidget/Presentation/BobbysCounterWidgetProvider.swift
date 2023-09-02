//
//  BobbysCounterWidgetProvider.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 18.07.23.
//

import WidgetKit

struct BobbysCounterWidgetProvider: AppIntentTimelineProvider {

	// MARK: - Use Cases

	private let fetchCounterUseCase: PFetchCounterUseCase
	private let insertCounterUseCase: PInsertCounterUseCase

	// MARK: - Life Cycle

	init(fetchCounterUseCase: PFetchCounterUseCase,
		 insertCounterUseCase: PInsertCounterUseCase) {
		self.fetchCounterUseCase = fetchCounterUseCase
		self.insertCounterUseCase = insertCounterUseCase
	}

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
		guard let configuration else {
			return CounterIntent()
		}
		let counter = fetchCounter()
		configuration.count = counter.count
		configuration.date = counter.date.relative
		return configuration
	}

	/// Fetch counter matching selected date otherwise insert new counter and return object
	private func fetchCounter() -> Counter {
		guard let fetchedCounter = fetchCounterUseCase
			.fetchCounter(selectedDate: .now) else {
			return insertCounterUseCase
				.insertCounter(selectedDate: .now)
		}
		return fetchedCounter
	}
}
