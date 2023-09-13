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

	@State var viewModel: SettingsViewModel

	// MARK: - Private Properties

	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var modelContext
	@Query(sort: \Counter.date,
		   order: .forward) private var counters: [Counter]

	// MARK: - Layouts

	var body: some View {
		NavigationStack {
			VStack {
				DatePicker("SelectedDate",
						   selection: $viewModel.counterSelected.selectedDate,
						   in: ...Date.now,
						   displayedComponents: [.date])
				.datePickerStyle(.compact)
				.padding()
				.accessibilityIdentifier("DatePicker")

				Group {
					if counters.count > 1 {
						Chart {
							ForEach(counters) { counter in
								LineMark(x: .value("Date",
												   counter.date,
												   unit: .day),
										 y: .value("Count",
												   counter.count))
								.interpolationMethod(.monotone)
								.lineStyle(StrokeStyle(lineWidth: 1,
													   dash: [2]))

								PointMark(x: .value("Date",
													counter.date,
													unit: .day),
										  y: .value("Count",
													counter.count))
								.annotation(position: .topLeading,
											spacing: 4,
											overflowResolution: .init(x: .fit(to: .chart),
																	  y: .fit(to: .chart))) {
									if viewModel.showAnnotation(date: counter.date),
									   let selectedPointMarkCounter = viewModel.selectedPointMarkCounter(counters: counters) {
										VStack {
											Text(selectedPointMarkCounter.count.description)
												.font(.system(size: 100))
												.minimumScaleFactor(0.01)
												.lineLimit(1)
												.opacity(0.25)
												.padding(2)
										}
										.frame(width: 60,
											   height: 60)
										.background {
											RoundedRectangle(cornerRadius: 4)
												.fill(Color(uiColor: .systemBackground))
												.shadow(color: .black,
														radius: 2)
										}
										.overlay(alignment: .topTrailing) {
											Text(selectedPointMarkCounter.date.toRelative)
												.font(.system(size: 4))
												.padding(2)
										}
										.padding(2)
									}
								}
							}
						}
						.chartScrollableAxes(.horizontal)
						.chartScrollPosition(x: $viewModel.chartScrollPosition)
						.chartXVisibleDomain(length: viewModel.chartXVisibleDomainLength(counters: counters))
						.chartXSelection(value: $viewModel.selectedPointMarkDate)
						.chartXScale(range: .plotDimension(padding: 12))
						.chartYScale(range: .plotDimension(padding: 12))
						.foregroundStyle(.red)
						.accessibilityIdentifier("Chart")
						.onAppear {
							Task {
								withAnimation {
									let date = viewModel.counterSelected.selectedDate
									let dateMinusOne = Calendar.current.date(byAdding: DateComponents(day: -1),
																			 to: date) ?? date
									viewModel.chartScrollPosition = dateMinusOne
								}
							}
						}
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
				ToolbarItem(placement: .destructiveAction) {
					Button("Reset") {
						if UIDevice.current.userInterfaceIdiom == .pad {
							viewModel.showConfirmationDialogPad = true
						} else {
							viewModel.showConfirmationDialogPhone = true
						}
					}
					.accessibilityIdentifier("ResetButton")
				}

				ToolbarItem(placement: .cancellationAction) {
					Button {
						dismiss()
					} label: {
						Image(systemName: "xmark.circle.fill")
					}
					.accessibilityIdentifier("DismissButton")
				}

				ToolbarItem(placement: .bottomBar) {
					Button("Today") {
						viewModel.counterSelected.selectedDate = .now
					}
					.disabled(viewModel.counterSelected.selectedDate.isDateToday)
					.accessibilityIdentifier("TodayButton")
				}
			}
			.confirmationDialog("ResetConfirmationDialog",
								isPresented: $viewModel.showConfirmationDialogPhone,
								titleVisibility: .visible) {
				Button("Reset",
					   role: .destructive) {
					Task {
						try viewModel.reset()
					}
					dismiss()
				}
				.accessibilityIdentifier("ResetConfirmationDialogButtonPhone")
			}
			.alert("Reset", isPresented: $viewModel.showConfirmationDialogPad) {
				Button("Reset", role: .destructive) {
					Task {
						try viewModel.reset()
					}
					dismiss()
				}
				.accessibilityIdentifier("ResetConfirmationDialogButtonPad")
			} message: {
				Text("ResetConfirmationDialog")
			}
			.alert(isPresented: $viewModel.showAlert,
				   error: viewModel.alertError) { _ in
			} message: { error in
				if let message = error.recoverySuggestion {
					Text(message)
				}
			}
			.onChange(of: viewModel.counterSelected.selectedDate) {
				viewModel.fetchCounter()
				dismiss()
			}
		}
		.presentationDetents([.fraction(0.4)])
		.fontWeight(.bold)
		.fontDesign(.monospaced)
		.tint(.red)
	}
}

#Preview {
	Color
		.clear
		.sheet(isPresented: .constant(true)) {
			SettingsView(viewModel: ViewModelDI.shared.settingsViewModel(counterSelected: CounterSelected()))
				.modelContainer(DataController.shared.modelContainer)
	}
}
