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
	@Query(sort: \Counter.date,
		   order: .reverse) private var counters: [Counter]
	@State private var sensoryFeedback: SensoryFeedback = .success
	@State private var sensoryFeedbackTrigger = false
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
				CountersView(alert: alert,
							 selected: selected,
							 showCountersSheet: $showCountersSheet,
							 dismiss: {
					sensoryFeedback = .selection
					sensoryFeedbackTrigger = true
					dismiss()
				})
			}
			.onChange(of: selected.date) { _, newValue in
				do {
					try Counter.fetch(date: newValue)
					sensoryFeedback = .selection
					sensoryFeedbackTrigger = true
					dismiss()
				} catch {
					alert.error = .fetch
					alert.show = true
					sensoryFeedback = .error
					sensoryFeedbackTrigger = true
				}
			}
		}
		.presentationDetents([.fraction(counters.isEmpty ? 0.6 : 0.4)])
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
