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

	@Bindable var selected: Selected
	@Binding var showCountersSheet: Bool

	// MARK: - Private Properties

	@Environment(\.modelContext) private var modelContext
	@Query(sort: \Counter.date,
		   order: .reverse) private var counters: [Counter]
	@State private var counterDelete: Counter?
	@State private var sensoryFeedback: SensoryFeedback = .success
	@State private var sensoryFeedbackTrigger = false
	@State private var showDeleteConfirmationDialog = false
	@State private var showResetConfirmationDialog = false
	private var filteredCounters: [Counter] {
		counters.filter { $0 != selected.counter }
	}

	// MARK: - Layouts

	var body: some View {
		NavigationStack {
			List {
				if let counter = selected.counter {
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
					if let counterDelete {
						counterDelete.delete(modelContext)
						if counterDelete == selected.counter {
							selected.date = .now
						}
						sensoryFeedback = .success
						sensoryFeedbackTrigger = true
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
						counter.delete(modelContext)
					}
					selected.date = .now
					sensoryFeedback = .success
					sensoryFeedbackTrigger = true
				}
				.accessibilityIdentifier("ResetConfirmationDialogButton")
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
			selected.date = counter.date
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
}

#Preview {
	CountersView(selected: Selected(),
				 showCountersSheet: .constant(true))
		.modelContainer(for: Counter.self,
						inMemory: true)
}
