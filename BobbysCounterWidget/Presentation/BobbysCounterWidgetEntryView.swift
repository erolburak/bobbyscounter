//
//  BobbysCounterWidgetEntryView.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 18.07.23.
//

import SwiftData
import SwiftUI

struct BobbysCounterWidgetEntryView: View {

	// MARK: - Private Properties

	@Query(sort: \Counter.date,
		   order: .reverse) private var counters: [Counter]
	private var count: Int? {
		counters.first { $0.date == .now.toDateWithoutTime }?.count
	}
	private var decreaseDisabled: Bool {
		count == nil || count == 0
	}
	private var isCountNil: Bool {
		count == nil
	}

	// MARK: - Properties

	let entry: BobbysCounterWidgetProvider.Entry

	// MARK: - Layouts

	var body: some View {
		ZStack {
			if isCountNil {
				Text("EmptyCount")
			} else if let count {
				Text(count.description)
					.font(.system(size: 100))
					.minimumScaleFactor(0.01)
					.lineLimit(1)
					.opacity(0.25)
					.padding()
					.contentTransition(.numericText())

				HStack {
					Button("Minus",
						   intent: DecreaseIntent())
					.frame(maxWidth: .infinity)
					.disabled(decreaseDisabled)

					Button("Plus",
						   intent: IncreaseIntent())
					.frame(maxWidth: .infinity)
				}
				.font(.system(size: 70))
				.buttonStyle(.plain)
			}
		}
		.ignoresSafeArea(.all)
		.overlay(alignment: .topTrailing) {
			if !isCountNil {
				Text(entry.date.toRelative)
					.font(.system(size: 8))
			}
		}
		.fontWeight(.bold)
		.monospaced()
		.widgetAccentable()
	}
}
