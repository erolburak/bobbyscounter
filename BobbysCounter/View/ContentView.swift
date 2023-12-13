//
//  ContentView.swift
//  BobbysCounter
//
//  Created by Burak Erol on 27.06.23.
//

import SwiftData
import SwiftUI

struct ContentView: View {

	// MARK: - Properties

	@Bindable var alert: Alert
	@Bindable var selected: Selected

	// MARK: - Private Properties

	@Environment(\.modelContext) private var modelContext
	@Query private var counters: [Counter]
	@State private var sensoryFeedback: SensoryFeedback = .increase
	@State private var sensoryFeedbackTrigger = false
	@State private var showSettingsSheet = false

	// MARK: - Layouts

	var body: some View {
		ZStack {
			Text(selected.counter?.count.description ?? "0")
				.font(.system(size: 1000))
				.minimumScaleFactor(0.001)
				.lineLimit(1)
				.opacity(0.25)
				.padding()
				.accessibilityIdentifier("CountText")

			HStack {
				Button {
					selected.counter?.decrease()
					sensoryFeedback = .decrease
					sensoryFeedbackTrigger = true
				} label: {
					Text("Minus")
						.frame(maxWidth: .infinity)
				}
				.disabled(selected.counter?.count == 0)
				.accessibilityIdentifier("MinusButton")

				Button {
					selected.counter?.increase()
					sensoryFeedback = .increase
					sensoryFeedbackTrigger = true
				} label: {
					Text("Plus")
						.frame(maxWidth: .infinity)
				}
				.accessibilityIdentifier("PlusButton")
			}
			.frame(maxHeight: .infinity)
			.font(.system(size: 140.0))
		}
		.ignoresSafeArea(.all)
		.overlay(alignment: .topTrailing) {
			Text(selected.counter?.date.toRelative ?? "")
				.font(.system(size: 8))
				.padding(.trailing)
				.accessibilityIdentifier("DateText")
		}
		.overlay(alignment: .bottom) {
			Button("Settings") {
				showSettingsSheet = true
			}
			.padding(.bottom)
			.accessibilityIdentifier("SettingsButton")
		}
		.sheet(isPresented: $showSettingsSheet) {
			SettingsView(alert: alert,
						 selected: selected)
		}
		.fontWeight(.bold)
		.fontDesign(.monospaced)
		.tint(.accent)
		.sensoryFeedback(sensoryFeedback,
						 trigger: sensoryFeedbackTrigger) { _, newValue in
			sensoryFeedbackTrigger = false
			return newValue == true
		}
	}
}

#Preview {
	ContentView(alert: Alert(),
				selected: Selected())
		.modelContainer(for: Counter.self,
						inMemory: true)
}
