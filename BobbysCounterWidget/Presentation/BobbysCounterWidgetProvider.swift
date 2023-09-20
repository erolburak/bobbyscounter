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

	// MARK: - Actions

	@MainActor
	func placeholder(in context: Context) -> BobbysCounterWidgetEntry {
		BobbysCounterWidgetEntry(configurationIntent: ConfigurationIntent(),
								 counter: setCounter())
	}

	func snapshot(for configuration: ConfigurationIntent,
				  in context: Context) async -> BobbysCounterWidgetEntry {
		await BobbysCounterWidgetEntry(configurationIntent: ConfigurationIntent(),
									   counter: setCounter())
	}

	func timeline(for configuration: ConfigurationIntent,
				  in context: Context) async -> Timeline<BobbysCounterWidgetEntry> {
		await Timeline(entries: [BobbysCounterWidgetEntry(configurationIntent: ConfigurationIntent(),
														  counter: setCounter())],
					   policy: .atEnd)
	}

	@MainActor
	private func setCounter() -> Counter {
		guard let counter = fetchCounter() else {
			return Counter(count: 0,
						   date: .now)
		}
		return counter
	}

	private func fetchCounter() -> Counter? {
		guard let fetchedCounter = fetchCounterUseCase.fetch(selectedDate: .now) else {
			return insertCounterUseCase.insert(selectedDate: .now)
		}
		return fetchedCounter
	}
}
