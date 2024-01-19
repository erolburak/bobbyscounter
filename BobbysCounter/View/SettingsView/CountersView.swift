//
//  CountersView.swift
//  BobbysCounter
//
//  Created by Burak Erol on 13.12.23.
//

import SwiftData
import SwiftUI

struct CountersView: View {

	// MARK: - Properties

	@Bindable var alert: Alert
	@Bindable var selected: Selected
	@Binding var showCountersSheet: Bool
	var dismiss: () -> Void

	// MARK: - Private Properties

	@Query(sort: \Counter.date,
		   order: .reverse) private var counters: [Counter]
	@State private var counterDelete: Counter?
	@State private var sensoryFeedback: SensoryFeedback = .success
	@State private var sensoryFeedbackTrigger = false
	@State private var showDeleteConfirmationDialog = false
	@State private var showResetConfirmationDialog = false
	private var counter: Counter? {
		counters.first { $0.date == selected.date }
	}
	private var filteredCounters: [Counter] {
		counters.filter { $0.date != selected.date }
	}

	// MARK: - Layouts

	var body: some View {
		NavigationStack {
			Group {
				if !counters.isEmpty {
					List {
						if let counter {
							Section {
								ListItem(counter: counter)
							} header: {
								Text("SelectedCounter")
							}
						}

						if !filteredCounters.isEmpty {
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
				} else {
					ContentUnavailableView {
						Label("EmptyCounters",
							  systemImage: "list.bullet.circle.fill")
					} description: {
						Text("EmptyCountersMessage")
					}
				}
			}
			.navigationTitle("Counters")
			.navigationBarTitleDisplayMode(.inline)
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
					if let counterDelete {
						if counterDelete.date?.isDateToday == true {
							counterDelete.reset()
							self.counterDelete = nil
							sensoryFeedback = .success
							sensoryFeedbackTrigger = true
						} else {
							counterDelete.delete()
							if counterDelete == counter {
								do {
									try Counter.fetch(date: .now)
									selected.date = .now.toDateWithoutTime ?? .now
									sensoryFeedback = .success
									sensoryFeedbackTrigger = true
									dismiss()
								} catch {
									alert.error = .fetch
									alert.show = true
									sensoryFeedback = .error
									sensoryFeedbackTrigger = true
								}
							} else {
								sensoryFeedback = .success
								sensoryFeedbackTrigger = true
							}
							self.counterDelete = nil
						}
					}
				}
				.accessibilityIdentifier("DeleteConfirmationDialogButton")
			}
			.confirmationDialog("ResetConfirmationDialog",
								isPresented: $showResetConfirmationDialog,
								titleVisibility: .visible) {
				Button("Reset",
					   role: .destructive) {
					counters.forEach { counter in
						if counter.date?.isDateToday == true {
							counter.reset()
						} else {
							counter.delete()
						}
					}
					selected.average = 7
					selected.date = .now.toDateWithoutTime ?? .now
					dismiss()
				}
				.accessibilityIdentifier("ResetConfirmationDialogButton")
			}
			.sensoryFeedback(sensoryFeedback,
							 trigger: sensoryFeedbackTrigger) { _, newValue in
				sensoryFeedbackTrigger = false
				return newValue == true
			}
		}
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
			guard let date = counter.date else {
				return
			}
			if counter == self.counter {
				dismiss()
			} else {
				selected.date = date
			}
		} label: {
			HStack(spacing: 20) {
				Text(counter.date?.toRelative ?? "")

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
}

#Preview {
	CountersView(alert: Alert(),
				 selected: Selected(),
				 showCountersSheet: .constant(true),
				 dismiss: {})
		.modelContainer(for: Counter.self,
						inMemory: true)
}
