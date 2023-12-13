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

	@Bindable var counterSelected: CounterSelected

	// MARK: - Private Properties

	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var modelContext
	@Query(sort: \Counter.date,
		   order: .reverse) private var counters: [Counter]
	@State private var alertError: Errors?
	@State private var chartScrollPosition = Date.now
	@State private var counterDelete: Counter?
	@State private var selectedPointMarkDate: Date?
	@State private var sensoryFeedback: SensoryFeedback = .success
	@State private var sensoryFeedbackTrigger = false
	@State private var showAlert = false
	@State private var showCountersSheet = false
	@State private var showDeleteConfirmationDialog = false
	@State private var showResetConfirmationDialog = false

	// MARK: - Layouts

	var body: some View {
		NavigationStack {
			VStack {
				DatePicker("SelectedDate",
						   selection: $counterSelected.selectedDate,
						   in: ...Date.now,
						   displayedComponents: [.date])
				.datePickerStyle(.compact)
				.padding()
				.accessibilityIdentifier("DatePicker")

				if counters.count > 1 {
					ChartView()
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
						counterSelected.selectedDate = .now
					}
					.disabled(counterSelected.selectedDate.isDateToday)
					.accessibilityIdentifier("TodayButton")
				}
			}
			.sheet(isPresented: $showCountersSheet) {
				ListView()
			}
			.alert(isPresented: $showAlert,
				   error: alertError) { _ in
			} message: { error in
				if let message = error.recoverySuggestion {
					Text(message)
				}
			}
			.onChange(of: counterSelected.selectedDate) { _, newValue in
				var counter = counters.first { Calendar.current.isDate($0.date,
																		inSameDayAs: newValue) }
				if newValue <= .now,
				   counter == nil {
					let newCounter = Counter(count: 0,
											 date: newValue)
					modelContext.insert(newCounter)
					counter = newCounter
				}
				counterSelected.counter = counter
				sensoryFeedback = .selection
				sensoryFeedbackTrigger = true
				dismiss()
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

	private func ChartView() -> some View {
		Chart(counters) { counter in
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
				if showAnnotation(date: counter.date),
				   let selectedPointMarkCounter = selectedPointMarkCounter(counters: counters) {
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
		.chartScrollPosition(x: $chartScrollPosition)
		.chartXVisibleDomain(length: chartXVisibleDomainLength(counters: counters))
		.chartXSelection(value: $selectedPointMarkDate)
		.chartXScale(range: .plotDimension(padding: 12))
		.chartYScale(range: .plotDimension(padding: 12))
		.frame(height: 120)
		.fixedSize(horizontal: false,
				   vertical: true)
		.padding(.horizontal)
		.font(.system(size: 10))
		.foregroundStyle(.red)
		.task {
			let date = counterSelected.selectedDate
			let dateMinusOne = Calendar.current.date(byAdding: DateComponents(day: -1),
													 to: date) ?? date
			chartScrollPosition = dateMinusOne
		}
		.accessibilityIdentifier("Chart")
	}

	private func DeleteButton(counter: Counter,
							  isContextMenu: Bool) -> some View {
		Button(role: .destructive) {
			counterDelete = counter
			showDeleteConfirmationDialog = true
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

	private func ListItem(counter: Counter) -> some View {
		Button {
			counterSelected.selectedDate = counter.date
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

	private func ListView() -> some View {
		NavigationStack {
			List {
				if let counter = counterSelected.counter {
					Section {
						ListItem(counter: counter)
					} header: {
						Text("SelectedCounter")
					}
				}

				let filteredCounters = counters.filter { $0 != counterSelected.counter }

				if filteredCounters.isEmpty == false {
					Section {
						ForEach(filteredCounters) { counter in
							ListItem(counter: counter)
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
						showResetConfirmationDialog = true
					} label: {
						Label("Reset",
							  systemImage: "trash.circle.fill")
					}
					.accessibilityIdentifier("ResetButton")
				}

				ToolbarItem(placement: .cancellationAction) {
					Button {
						showCountersSheet = false
					} label: {
						Image(systemName: "xmark.circle.fill")
					}
					.accessibilityIdentifier("CloseCountersButton")
				}
			}
			.confirmationDialog("DeleteConfirmationDialog",
								isPresented: $showDeleteConfirmationDialog,
								titleVisibility: .visible) {
				Button("Delete",
					   role: .destructive) {
					delete()
				}
				.accessibilityIdentifier("DeleteConfirmationDialogButton")
			}
			.confirmationDialog("ResetConfirmationDialog",
								isPresented: $showResetConfirmationDialog,
								titleVisibility: .visible) {
				Button("Reset",
					   role: .destructive) {
					reset()
					dismiss()
				}
				.accessibilityIdentifier("ResetConfirmationDialogButton")
			}
		}
	}

	// MARK: - Actions

	private func delete() {
		if let counter = counterDelete {
			modelContext.delete(counter)
			counterDelete = nil
			if counter == counterSelected.counter {
				counterSelected.selectedDate = .now
			}
			sensoryFeedback = .success
			sensoryFeedbackTrigger = true
		}
	}

	private func reset() {
		do {
			try modelContext.enumerate(FetchDescriptor<Counter>()) { counter in
				modelContext.delete(counter)
			}
			counterSelected.selectedDate = .now
			sensoryFeedback = .success
			sensoryFeedbackTrigger = true
		} catch {
			showAlert(error: .reset)
		}
	}

	private func showAlert(error: Errors) {
		alertError = error
		showAlert = true
		sensoryFeedback = .error
		sensoryFeedbackTrigger = true
	}

	private func showAnnotation(date: Date) -> Bool {
		date.formatted(date: .complete,
					   time: .omitted) == selectedPointMarkDate?.formatted(date: .complete,
																		   time: .omitted)
	}

	private func chartXVisibleDomainLength(counters: [Counter]) -> Int {
		/// Calculate factor by multiplying seconds, minutes and hours together
		let factor = 60 * 60 * 24
		let count = counters.count
		let range = 3...4
		return range.contains(count) ? count * factor : range.upperBound * factor
	}

	private func selectedPointMarkCounter(counters: [Counter]) -> Counter? {
		counters.first { Calendar.current.isDate($0.date,
												 inSameDayAs: selectedPointMarkDate ?? .now) }
	}
}

#Preview {
	Color
		.clear
		.sheet(isPresented: .constant(true)) {
			SettingsView(counterSelected: CounterSelected())
				.modelContainer(for: Counter.self,
								inMemory: true)
	}
}
