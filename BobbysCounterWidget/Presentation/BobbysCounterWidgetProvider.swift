//
//  BobbysCounterWidgetProvider.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 18.07.23.
//

import WidgetKit

struct BobbysCounterWidgetProvider: TimelineProvider {

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

	func getSnapshot(in context: Context,
					 completion: @escaping (BobbysCounterWidgetEntry) -> Void) {
		completion(BobbysCounterWidgetEntry(counter: setCounter()))
	}

	func getTimeline(in context: Context,
					 completion: @escaping (Timeline<BobbysCounterWidgetEntry>) -> Void) {
		completion(Timeline(entries: [BobbysCounterWidgetEntry(counter: setCounter())],
							policy: .atEnd))
	}

	func placeholder(in context: Context) -> BobbysCounterWidgetEntry {
		BobbysCounterWidgetEntry(counter: setCounter())
	}

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
