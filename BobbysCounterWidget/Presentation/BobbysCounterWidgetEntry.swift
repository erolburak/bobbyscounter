//
//  BobbysCounterWidgetEntry.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 18.07.23.
//

import WidgetKit

struct BobbysCounterWidgetEntry: TimelineEntry {

	// MARK: - Properties

	let count: Int?
	let date = Date.now
	var decreaseDisabled: Bool {
		count == nil || count == 0
	}
	var increaseDisabled: Bool {
		count == nil
	}
}
