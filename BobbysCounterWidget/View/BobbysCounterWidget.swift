//
//  BobbysCounterWidget.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 06.07.23.
//

import SwiftUI
import WidgetKit

struct BobbysCounterWidget: Widget {

	// MARK: - Properties

	let kind: String = "BobbysCounterWidget"

	// MARK: - Layouts

	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind,
							provider: BobbysCounterWidgetProvider()) { entry in
			BobbysCounterWidgetEntryView(entry: entry)
				.containerBackground(.widgetBackground,
									 for: .widget)
		}
		.configurationDisplayName("AppName")
		.description("WidgetDescription")
	}
}
