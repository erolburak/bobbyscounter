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

	@Bindable var selected: Selected

	// MARK: - Private Properties

	@Environment(\.dismiss) private var dismiss
	@Environment(Alert.self) private var alert
	@Environment(Sensory.self) private var sensory
	@Query(sort: \Counter.date,
		   order: .reverse) private var counters: [Counter]
	@State private var showAverageSheet = false
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

				if !counters.isEmpty {
					ChartView(selected: selected)
				} else {
					ContentUnavailableView {
						Label("EmptyCharts",
							  systemImage: "chart.xyaxis.line")
					} description: {
						Text("EmptyCountersMessage")
							.accessibilityIdentifier("EmptyCountersMessage")
					}
				}

				Spacer()
			}
			.navigationTitle("Settings")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						showAverageSheet = true
					} label: {
						Label("Average",
							  systemImage: "divide.circle.fill")
					}
					.accessibilityIdentifier("AverageButton")
				}

				ToolbarItem(placement: .primaryAction) {
					Button {
						showCountersSheet = true
					} label: {
						Label("Counters",
							  systemImage: "list.bullet.circle.fill")
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
						selected.date = .now.toDateWithoutTime ?? .now
					}
					.disabled(selected.date.isDateToday)
					.accessibilityIdentifier("TodayButton")
				}
			}
			.sheet(isPresented: $showAverageSheet) {
				AverageView(selected: selected,
							showAverageSheet: $showAverageSheet)
			}
			.sheet(isPresented: $showCountersSheet) {
				CountersView(selected: selected,
							 showCountersSheet: $showCountersSheet,
							 dismiss: {
					sensory.feedbackTrigger(feedback: .selection)
					dismiss()
				})
			}
			.onChange(of: selected.date) { _, newValue in
				do {
					try Counter.fetch(date: newValue)
					sensory.feedbackTrigger(feedback: .selection)
					dismiss()
				} catch {
					alert.error = .fetch
					alert.show = true
					sensory.feedbackTrigger(feedback: .error)
				}
			}
		}
		.presentationDetents([.fraction(counters.isEmpty ? 0.6 : 0.4)])
		.fontWeight(.bold)
		.monospaced()
		.tint(.red)
	}
}

#Preview {
	Color
		.clear
		.sheet(isPresented: .constant(true)) {
			SettingsView(selected: Selected())
				.environment(Alert())
				.environment(Sensory())
				.modelContainer(for: Counter.self,
								inMemory: true)
	}
}
