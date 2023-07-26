//
//  CounterIntent.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 26.07.23.
//

import AppIntents

struct CounterIntent: WidgetConfigurationIntent {

	// MARK: - Properties

	static var title: LocalizedStringResource = "Counter"

	@Parameter(title: "Count",
			   default: 0)
	var count: Int

	@Parameter(title: "Date",
			   default: "Today")
	var date: String
}
