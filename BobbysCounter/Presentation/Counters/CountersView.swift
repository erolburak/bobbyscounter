//
//  CountersView.swift
//  BobbysCounter
//
//  Created by Burak Erol on 13.12.23.
//

import SwiftData
import SwiftUI

struct CountersView: View {
    // MARK: - Private Properties

    @Environment(Alert.self) private var alert
    @Environment(Sensory.self) private var sensory
    @State private var showDeleteConfirmationDialog = false
    private var counters: [Counter] {
        selected.category?.countersSorted ?? []
    }
    private var countersWithoutSelectedDate: [Counter] {
        counters.lazy.filter { $0.date != selected.date }
    }

    // MARK: - Properties

    @Bindable var selected: Selected
    @Binding var showCountersSheet: Bool
    let dismiss: () -> Void

    // MARK: - Layouts

    var body: some View {
        NavigationStack {
            Group {
                if !counters.isEmpty {
                    List {
                        if let counter = selected.counter {
                            Section {
                                CountersListItem(
                                    selected: selected,
                                    counter: counter,
                                    dismiss: dismiss
                                )
                            } header: {
                                Text("SelectedCounter")
                            }
                        }

                        if !countersWithoutSelectedDate.isEmpty {
                            Section {
                                ForEach(countersWithoutSelectedDate) {
                                    CountersListItem(
                                        selected: selected,
                                        counter: $0,
                                        dismiss: dismiss
                                    )
                                }
                            } header: {
                                Text("Counters")
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                } else {
                    ContentUnavailableView {
                        Label(
                            "EmptyCounters",
                            systemImage: "square.stack.3d.up"
                        )
                    } description: {
                        Text("EmptyCountersMessage")
                    }
                    .symbolEffect(
                        .bounce,
                        options: .nonRepeating
                    )
                    .symbolVariant(.fill)
                }
            }
            .navigationTitle("Counters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button(role: .destructive) {
                        showDeleteConfirmationDialog = true
                    }
                    .disabled(counters.isEmpty)
                    .tint(.red)
                    .confirmationDialog(
                        "DeleteCountersConfirmationDialog",
                        isPresented: $showDeleteConfirmationDialog,
                        titleVisibility: .visible
                    ) {
                        Button(
                            "Delete",
                            role: .destructive
                        ) {
                            Task {
                                do {
                                    try await Counter.delete(
                                        ids: counters.lazy.map(\.persistentModelID))
                                    selected.counter = nil
                                    dismiss()
                                } catch {
                                    sensory.feedback(.error)
                                    alert.error = .fetch
                                    alert.show = true
                                }
                            }
                        }
                        .accessibilityIdentifier(
                            Accessibility.deleteCountersButtonConfirmationDialog.id)
                    }
                    .accessibilityIdentifier(Accessibility.deleteCountersButton.id)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel) {
                        showCountersSheet = false
                    }
                    .accessibilityIdentifier(Accessibility.closeCountersButton.id)
                }
            }
            .onChange(of: showDeleteConfirmationDialog) {
                sensory.feedback(.impact)
            }
        }
        .presentationDetents(
            [
                .medium,
                .large,
            ]
        )
    }
}

#Preview("CountersView") {
    CountersView(
        selected: Selected(),
        showCountersSheet: .constant(true)
    ) {}
    .environment(Alert())
    .environment(Sensory())
}
