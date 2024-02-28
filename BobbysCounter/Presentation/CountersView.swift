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
	let dismiss: () -> Void

	// MARK: - Private Properties

	@Environment(Alert.self) private var alert
	@Environment(Sensory.self) private var sensory
	@Query(sort: \Counter.date,
		   order: .reverse) private var counters: [Counter]
	@State private var counterDelete: Counter?
	@State private var showDeleteConfirmationDialog = false
	@State private var showResetConfirmationDialog = false
	private var filteredCounters: [Counter] {
		counters.filter { $0.date != selected.date }
	}

	// MARK: - Layouts

	var body: some View {
		NavigationStack {
			Group {
				if !counters.isEmpty {
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
					.confirmationDialog("ResetConfirmationDialog",
										isPresented: $showResetConfirmationDialog,
										titleVisibility: .visible) {
						Button("Reset",
							   role: .destructive) {
							Task {
								await CounterActor.shared.delete(counters: counters)
								do {
									selected.average = 7
									selected.counter = try await CounterActor.shared.fetch(date: .now)
									selected.date = .now.toDateWithoutTime ?? .now
									sensory.feedbackTrigger(feedback: .success)
									dismiss()
								} catch {
									alert.error = .fetch
									alert.show = true
									sensory.feedbackTrigger(feedback: .error)
								}
							}
						}
						.accessibilityIdentifier("ResetConfirmationDialogButton")
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
		}
	}

	private func DeleteButton(counter: Counter,
							  isContextMenu: Bool) -> some View {
		Button {
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
			if counter == selected.counter {
				sensory.feedbackTrigger(feedback: .selection)
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
		.confirmationDialog("DeleteConfirmationDialog",
							isPresented: $showDeleteConfirmationDialog,
							titleVisibility: .visible) {
			Button("Delete",
				   role: .destructive) {
				Task {
					guard let counterDelete else {
						return
					}
					await CounterActor.shared.delete(counters: [counterDelete])
					if counterDelete == selected.counter {
						do {
							selected.counter = try await CounterActor.shared.fetch(date: .now)
							selected.date = .now.toDateWithoutTime ?? .now
							sensory.feedbackTrigger(feedback: .success)
							dismiss()
						} catch {
							alert.error = .fetch
							alert.show = true
							sensory.feedbackTrigger(feedback: .error)
						}
					} else {
						sensory.feedbackTrigger(feedback: .success)
					}
				}
			}
			.accessibilityIdentifier("DeleteConfirmationDialogButton")
		}
	}
}

#Preview {
	CountersView(selected: Selected(),
				 showCountersSheet: .constant(true),
				 dismiss: {})
		.environment(Alert())
		.environment(Sensory())
		.modelContainer(inMemory: true)
}
