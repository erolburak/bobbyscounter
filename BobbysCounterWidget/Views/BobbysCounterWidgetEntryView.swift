//
//  BobbysCounterWidgetEntryView.swift
//  BobbysCounterWidget
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
			Text(entry.counterIntent.count.description)
				.font(.system(size: 100))
				.minimumScaleFactor(0.01)
				.lineLimit(1)
				.opacity(0.25)
				.padding()

			HStack {
				Button(intent: DecreaseIntent()) {
					Text("Minus")
						.frame(maxWidth: .infinity,
							   maxHeight: .infinity)
				}
				.disabled(entry.counterIntent.count == 0)

				Button(intent: IncreaseIntent()) {
					Text("Plus")
						.frame(maxWidth: .infinity,
							   maxHeight: .infinity)
				}
			}
			.font(.system(size: 70))
			.buttonStyle(.plain)
		}
		.edgesIgnoringSafeArea(.all)
		.overlay(alignment: .topTrailing) {
			Text(entry.counterIntent.date)
				.font(.system(size: 8))
		}
		.fontWeight(.bold)
		.fontDesign(.monospaced)
		.tint(.accent)
	}
}
