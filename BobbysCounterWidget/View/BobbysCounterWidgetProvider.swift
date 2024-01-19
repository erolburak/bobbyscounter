//
//  BobbysCounterWidgetProvider.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 18.07.23.
//

import WidgetKit

struct BobbysCounterWidgetProvider: TimelineProvider {

	// MARK: - Actions

	@MainActor
	func getSnapshot(in context: Context,
					 completion: @escaping (BobbysCounterWidgetEntry) -> Void) {
		completion(BobbysCounterWidgetEntry(counter: fetchCounter()))
	}

	@MainActor
	func getTimeline(in context: Context,
					 completion: @escaping (Timeline<BobbysCounterWidgetEntry>) -> Void) {
		completion(Timeline(entries: [BobbysCounterWidgetEntry(counter: fetchCounter())],
							policy: .atEnd))
	}

	@MainActor
	func placeholder(in context: Context) -> BobbysCounterWidgetEntry {
		BobbysCounterWidgetEntry(counter: fetchCounter())
	}

	@MainActor
	private func fetchCounter() -> Counter? {
		do {
			return try Counter.fetch(date: .now)
		} catch {
			return nil
		}
	}
}
