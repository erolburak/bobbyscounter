//
//  BobbysCounterWidgetEntry.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 18.07.23.
//

import WidgetKit

struct BobbysCounterWidgetEntry: TimelineEntry {
    // MARK: - Properties

    let categoryEntity: CategoryEntity?
    let date = Date.now
}
