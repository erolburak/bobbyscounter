//
//  BobbysCounterWidgetEntryView.swift
//  BobbysCounter
//
//  Created by Burak Erol on 18.07.23.
//

import SwiftUI

struct BobbysCounterWidgetEntryView: View {

	// MARK: - Properties

	var entry: BobbysCounterWidgetProvider.Entry

	// MARK: - Layouts

	var body: some View {
		ZStack {
			Text(entry.counter.count.description)
				.font(.system(size: 100000.0,
							  weight: .bold,
							  design: .monospaced))
				.minimumScaleFactor(0.001)
				.lineLimit(1)
				.opacity(0.25)

			HStack {
				Button(intent: DecreaseIntent()) {
					Text("Minus")
						.frame(maxWidth: .infinity,
							   maxHeight: .infinity)
				}
				.disabled(entry.counter.count == 0)

				Button(intent: IncreaseIntent()) {
					Text("Plus")
						.frame(maxWidth: .infinity,
							   maxHeight: .infinity)
				}
			}
			.buttonStyle(.plain)
		}
		.edgesIgnoringSafeArea(.all)
		.overlay(alignment: .topTrailing) {
			Text(entry.counter.date.relative)
				.font(.system(size: 8,
							  weight: .bold,
							  design: .monospaced))
		}
		.font(.system(size: 100.0,
					  weight: .bold,
					  design: .monospaced))
		.tint(.accent)
	}
}
