//
//  BobbysCounterWidgetProvider.swift
//  BobbysCounter
//
//  Created by Burak Erol on 18.07.23.
//

import SwiftData
import WidgetKit

struct BobbysCounterWidgetProvider: TimelineProvider {

	// MARK: - Properties

	@MainActor
	func placeholder(in context: Context) -> BobbysCounterWidgetEntry {
		BobbysCounterWidgetEntry(counter: fetchCounter())
	}

	@MainActor
	func getSnapshot(in context: Context,
					 completion: @escaping (BobbysCounterWidgetEntry) -> ()) {
		let entry = BobbysCounterWidgetEntry(counter: fetchCounter())
		completion(entry)
	}

	@MainActor
	func getTimeline(in context: Context,
					 completion: @escaping (Timeline<BobbysCounterWidgetEntry>) -> ()) {
		let timeline = Timeline(entries: [BobbysCounterWidgetEntry(counter: fetchCounter())],
								policy: .atEnd)
		completion(timeline)
	}

	/// Fetch todays counter and return object
	@MainActor
	private func fetchCounter() -> Counter {
		guard let modelContainer = try? ModelContainer(for: [Counter.self]),
			  let counter = try? Repository.shared.fetchTodaysCounter(modelContext: modelContainer.mainContext) else {
			return Counter(count: 0,
						   date: .now)
		}
		return counter
	}
}
