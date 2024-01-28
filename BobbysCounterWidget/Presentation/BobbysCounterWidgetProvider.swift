//
//  BobbysCounterWidgetProvider.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 18.07.23.
//

import WidgetKit

struct BobbysCounterWidgetProvider: TimelineProvider {

	// MARK: - Private Properties

	private var count: Int? {
		do {
			return try Counter.fetch(date: .now).count
		} catch {
			return nil
		}
	}

	// MARK: - Actions

	func getSnapshot(in context: Context,
					 completion: @escaping (BobbysCounterWidgetEntry) -> Void) {
		completion(BobbysCounterWidgetEntry(count: count))
	}

	func getTimeline(in context: Context,
					 completion: @escaping (Timeline<BobbysCounterWidgetEntry>) -> Void) {
		completion(Timeline(entries: [BobbysCounterWidgetEntry(count: count)],
							policy: .atEnd))
	}

	func placeholder(in context: Context) -> BobbysCounterWidgetEntry {
		BobbysCounterWidgetEntry(count: count)
	}
}
