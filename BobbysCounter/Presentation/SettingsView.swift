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
		   order: .reverse) private var counters: [Counter]

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

				if counters.count > 1 {
					Chart(counters) { counter in
						LineMark(x: .value("Date",
										   counter.date),
								 y: .value("Count",
										   counter.count))
						.interpolationMethod(.monotone)
						.lineStyle(StrokeStyle(lineWidth: 1,
											   dash: [2]))

						PointMark(x: .value("Date",
											counter.date),
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
					.chartScrollableAxes(.horizontal)
					.chartScrollPosition(x: $viewModel.chartScrollPosition)
					.chartXVisibleDomain(length: viewModel.chartXVisibleDomainLength(counters: counters))
					.chartXSelection(value: $viewModel.selectedPointMarkDate)
					.chartXScale(range: .plotDimension(padding: 12))
					.chartYScale(range: .plotDimension(padding: 12))
					.frame(height: 120)
					.fixedSize(horizontal: false,
							   vertical: true)
					.padding(.horizontal)
					.font(.system(size: 10))
					.foregroundStyle(.red)
					.task {
						let date = viewModel.counterSelected.selectedDate
						let dateMinusOne = Calendar.current.date(byAdding: DateComponents(day: -1),
																 to: date) ?? date
						viewModel.chartScrollPosition = dateMinusOne
					}
					.accessibilityIdentifier("Chart")
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
						viewModel.showCountersSheet = true
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
						viewModel.counterSelected.selectedDate = .now
					}
					.disabled(viewModel.counterSelected.selectedDate.isDateToday)
					.accessibilityIdentifier("TodayButton")
				}
			}
			.sheet(isPresented: $viewModel.showCountersSheet) {
				NavigationStack {
					List {
						if let counter = viewModel.counterSelected.counter {
							Section {
								Item(counter: counter)
							} header: {
								Text("SelectedCounter")
							}
						}

						let filteredCounters = counters.filter { $0 != viewModel.counterSelected.counter }

						if filteredCounters.isEmpty == false {
							Section {
								ForEach(filteredCounters) { counter in
									Item(counter: counter)
								}
							} header: {
								Text("Counters")
							}
						}
					}
					.listStyle(.insetGrouped)
					.navigationTitle("Counters")
					.navigationBarTitleDisplayMode(.inline)
					.overlay {
						if counters.isEmpty {
							ContentUnavailableView {
								Label("EmptyCounters",
									  systemImage: "list.bullet.rectangle.portrait.fill")
							} description: {
								Text("EmptyCountersMessage")
							}
						}
					}
					.toolbar {
						ToolbarItem(placement: .destructiveAction) {
							Button(role: .destructive) {
								if UIDevice.current.userInterfaceIdiom == .pad {
									viewModel.showResetConfirmationDialogPad = true
								} else {
									viewModel.showResetConfirmationDialogPhone = true
								}
							} label: {
								Label("Reset",
									  systemImage: "trash.circle.fill")
							}
							.accessibilityIdentifier("ResetButton")
						}

						ToolbarItem(placement: .cancellationAction) {
							Button {
								viewModel.showCountersSheet = false
							} label: {
								Image(systemName: "xmark.circle.fill")
							}
							.accessibilityIdentifier("CloseCountersButton")
						}
					}
					.confirmationDialog("DeleteConfirmationDialog",
										isPresented: $viewModel.showDeleteConfirmationDialogPhone,
										titleVisibility: .visible) {
						DeleteButton()
					}
					.confirmationDialog("ResetConfirmationDialog",
										isPresented: $viewModel.showResetConfirmationDialogPhone,
										titleVisibility: .visible) {
						ResetButton()
					}
					.alert("Delete",
						   isPresented: $viewModel.showDeleteConfirmationDialogPad) {
						DeleteButton()
					} message: {
						Text("DeleteConfirmationDialog")
					}
					.alert("Reset",
						   isPresented: $viewModel.showResetConfirmationDialogPad) {
						ResetButton()
					} message: {
						Text("ResetConfirmationDialog")
					}
				}
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
		.presentationDetents([.fraction(counters.count < 2 ? 0.6 : 0.4)])
		.fontWeight(.bold)
		.fontDesign(.monospaced)
		.tint(.red)
		.sensoryFeedback(viewModel.sensoryFeedback,
						 trigger: viewModel.sensoryFeedbackTrigger) { _, newValue in
			viewModel.sensoryFeedbackTrigger = false
			return newValue == true
		}
	}

	private func DeleteButton() -> some View {
		Button("Delete",
			   role: .destructive) {
			viewModel.delete()
		}
		.accessibilityIdentifier("DeleteConfirmationDialogButton")
	}

	private func DeleteButton(counter: Counter,
							  isContextMenu: Bool) -> some View {
		Button(role: .destructive) {
			viewModel.counterDelete = counter
			if UIDevice.current.userInterfaceIdiom == .pad {
				viewModel.showDeleteConfirmationDialogPad = true
			} else {
				viewModel.showDeleteConfirmationDialogPhone = true
			}
		} label: {
			if isContextMenu {
				Label("Delete",
					  systemImage: "trash.circle.fill")
			} else {
				Image(systemName: "trash")
			}
		}
		.accessibilityIdentifier("DeleteButton")
	}

	private func Item(counter: Counter) -> some View {
		Button {
			viewModel.counterSelected.selectedDate = counter.date
		} label: {
			HStack(spacing: 20) {
				Text(counter.date.toRelative)

				Spacer()

				Text(counter.count.description)
					.lineLimit(1)
			}
			.tint(.accent)
		}
		.contextMenu {
			DeleteButton(counter: counter,
						 isContextMenu: true)
		}
		.swipeActions(edge: .trailing,
					  allowsFullSwipe: true) {
			DeleteButton(counter: counter,
						 isContextMenu: false)
		}
	}

	private func ResetButton() -> some View {
		Button("Reset",
			   role: .destructive) {
			viewModel.reset()
			dismiss()
		}
		.accessibilityIdentifier("ResetConfirmationDialogButton")
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
