//
//  SettingsView.swift
//  BobbysCounter
//
//  Created by Burak Erol on 18.07.23.
//

import Charts
import SwiftData
import SwiftUI

struct SettingsView: View {

	// MARK: - Properties

	@Binding var counter: Counter?
	@Binding var selectedDate: Date
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var modelContext
	@Query(sort: \.date, order: .forward) private var counters: [Counter]
	@State var viewModel: SettingsViewModel

	// MARK: - Layouts

	var body: some View {
		NavigationStack {
			VStack {
				DatePicker("SelectedDate",
						   selection: $selectedDate,
						   in: ...Date(),
						   displayedComponents: [.date])
				.datePickerStyle(.compact)
				.padding()
				.accessibilityIdentifier("DatePicker")

				Group {
					if counters.count > 1 {
						Chart {
							ForEach(counters) { counter in
								LineMark(x: .value("Date",
												   counter.date),
										 y: .value("Count",
												   counter.count))
								.interpolationMethod(.catmullRom)
								.lineStyle(StrokeStyle(lineWidth: 1,
													   dash: [2]))

								PointMark(x: .value("Date",
													counter.date),
										  y: .value("Count",
													counter.count))
							}
						}
						.chartScrollableAxes(.horizontal)
						.chartScrollPosition(initialX: counters.last?.date ?? .now)
						.foregroundStyle(.red)
						.accessibilityIdentifier("Chart")
					} else {
						Text("ChartDescription")
							.multilineTextAlignment(.center)
							.opacity(0.25)
							.accessibilityIdentifier("ChartDescriptionText")
					}
				}
				.font(.system(size: 10))
				.frame(height: 120)
				.fixedSize(horizontal: false,
						   vertical: true)
				.padding(.horizontal)

				Spacer()
			}
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					Button("Reset") {
						viewModel.showConfirmationDialog.toggle()
					}
					.disabled(counters.isEmpty)
					.accessibilityIdentifier("ResetButton")
				}

				ToolbarItem(placement: .topBarTrailing) {
					Button {
						dismiss()
					} label: {
						Image(systemName: "xmark.circle.fill")
					}
					.accessibilityIdentifier("DismissButton")
				}

				ToolbarItem(placement: .bottomBar) {
					Button("Today") {
						selectedDate = .now
					}
					.disabled(selectedDate.isDateToday)
					.accessibilityIdentifier("TodayButton")
				}
			}
			.confirmationDialog("ConfirmationDialogTitle",
								isPresented: $viewModel.showConfirmationDialog,
								titleVisibility: .visible) {
				Button("Reset",
					   role: .destructive) {
					selectedDate = .now
					Task {
						counter = try await viewModel.reset(selectedDate: selectedDate)
					}
					dismiss()
				}
				.accessibilityIdentifier("ResetConfirmationButton")
			}
			.alert(isPresented: $viewModel.showAlert,
				   error: viewModel.alertError) { _ in
			} message: { error in
				if let message = error.recoverySuggestion {
					Text(message)
				}
			}
			.onChange(of: selectedDate) {
				Task {
					counter = try await viewModel.setCounter(counters: counters,
															 selectedDate: selectedDate)
				}
				dismiss()
			}
		}
		.presentationDetents([.fraction(0.4)])
		.fontWeight(.bold)
		.fontDesign(.monospaced)
		.tint(.red)
	}
}
