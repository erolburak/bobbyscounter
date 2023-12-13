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
			Text(entry.counter?.count.description ?? "")
				.font(.system(size: 100))
				.minimumScaleFactor(0.01)
				.lineLimit(1)
				.opacity(0.25)
				.padding()

			HStack {
				Button(intent: DecreaseIntent()) {
					Text("Minus")
						.frame(maxWidth: .infinity)
				}
				.disabled(entry.counter?.count == 0)

				Button(intent: IncreaseIntent()) {
					Text("Plus")
						.frame(maxWidth: .infinity)
				}
			}
			.font(.system(size: 70))
			.buttonStyle(.plain)
		}
		.ignoresSafeArea(.all)
		.overlay(alignment: .topTrailing) {
			Text(entry.counter?.date.toRelative ?? "")
				.font(.system(size: 8))
		}
		.fontWeight(.bold)
		.fontDesign(.monospaced)
		.tint(.accent)
	}
}
