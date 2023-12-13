//
//  SettingsView.swift
//  BobbysCounter
//
//  Created by Burak Erol on 18.07.23.
//

import SwiftData
import SwiftUI

struct SettingsView: View {

	// MARK: - Properties

	@Bindable var alert: Alert
	@Bindable var selected: Selected

	// MARK: - Private Properties

	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var modelContext
	@Query(sort: \Counter.date,
		   order: .reverse) private var counters: [Counter]
	@State private var sensoryFeedback: SensoryFeedback = .success
	@State private var sensoryFeedbackTrigger = false
	@State private var showCountersSheet = false

	// MARK: - Layouts

	var body: some View {
		NavigationStack {
			VStack {
				DatePicker("SelectedDate",
						   selection: $selected.date,
						   in: ...Date.now,
						   displayedComponents: [.date])
				.datePickerStyle(.compact)
				.padding()
				.accessibilityIdentifier("DatePicker")

				if counters.count > 1 {
					ChartView(selected: selected)
				}

				Spacer()
			}
			.navigationTitle("Settings")
			.navigationBarTitleDisplayMode(.inline)
			.overlay {
				if counters.count < 2 {
					ContentUnavailableView {
						Label("EmptyCharts",
							  systemImage: "chart.xyaxis.line")
					} description: {
						Text("EmptyChartsMessage")
							.accessibilityIdentifier("EmptyChartsMessage")
					}
				}
			}
			.toolbar {
				ToolbarItem(placement: .primaryAction) {
					Button {
						showCountersSheet = true
					} label: {
						Label("Counters",
							  systemImage: "list.bullet.rectangle.portrait.fill")
					}
					.accessibilityIdentifier("CountersButton")
				}

				ToolbarItem(placement: .cancellationAction) {
					Button {
						dismiss()
					} label: {
						Image(systemName: "xmark.circle.fill")
					}
					.accessibilityIdentifier("CloseSettingsButton")
				}

				ToolbarItem(placement: .bottomBar) {
					Button("Today") {
						selected.date = .now
					}
					.disabled(selected.date.isDateToday)
					.accessibilityIdentifier("TodayButton")
				}
			}
			.sheet(isPresented: $showCountersSheet) {
				CountersView(selected: selected,
							 showCountersSheet: $showCountersSheet)
			}
			.onChange(of: selected.date) { _, newValue in
				do {
					if newValue <= .now {
						selected.counter = try Counter.fetch(modelContext,
															 date: newValue)
						sensoryFeedback = .selection
						sensoryFeedbackTrigger = true
						dismiss()
					}
				} catch {
					alert.error = .fetch
					alert.show = true
					sensoryFeedback = .error
					sensoryFeedbackTrigger = true
				}
			}
		}
		.presentationDetents([.fraction(counters.count < 2 ? 0.6 : 0.4)])
		.fontWeight(.bold)
		.fontDesign(.monospaced)
		.tint(.red)
		.sensoryFeedback(sensoryFeedback,
						 trigger: sensoryFeedbackTrigger) { _, newValue in
			sensoryFeedbackTrigger = false
			return newValue == true
		}
	}
}

#Preview {
	Color
		.clear
		.sheet(isPresented: .constant(true)) {
			SettingsView(alert: Alert(),
						 selected: Selected())
				.modelContainer(for: Counter.self,
								inMemory: true)
	}
}
