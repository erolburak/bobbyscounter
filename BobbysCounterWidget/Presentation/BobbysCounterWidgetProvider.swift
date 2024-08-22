//
//  BobbysCounterWidgetProvider.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 18.07.23.
//

import WidgetKit

struct BobbysCounterWidgetProvider: TimelineProvider {
    // MARK: - Methods

    func getSnapshot(in context: Context,
                     completion: @escaping (BobbysCounterWidgetEntry) -> Void)
    {
        completion(BobbysCounterWidgetEntry())
    }

    func getTimeline(in context: Context,
                     completion: @escaping (Timeline<BobbysCounterWidgetEntry>) -> Void)
    {
        completion(Timeline(entries: [BobbysCounterWidgetEntry()],
                            policy: .atEnd))
    }

    func placeholder(in context: Context) -> BobbysCounterWidgetEntry {
        BobbysCounterWidgetEntry()
    }
}
