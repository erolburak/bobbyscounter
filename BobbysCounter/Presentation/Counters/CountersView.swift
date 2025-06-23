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
    @Query(
        sort: \Counter.date,
        order: .reverse
    ) private var counters: [Counter]
    @State private var showResetConfirmationDialog = false
    private var filteredCounters: [Counter] {
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

                        if !filteredCounters.isEmpty {
                            Section {
                                ForEach(filteredCounters) {
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
                            systemImage: "list.bullet"
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
                        showResetConfirmationDialog = true
                        sensory.feedback(feedback: .press(.button))
                    }
                    .tint(.red)
                    .confirmationDialog(
                        "ResetConfirmationDialog",
                        isPresented: $showResetConfirmationDialog,
                        titleVisibility: .visible
                    ) {
                        Button(
                            "Reset",
                            role: .destructive
                        ) {
                            Task {
                                try await CounterActor.shared.delete(
                                    ids: counters.lazy.map(\.persistentModelID)
                                )
                                do {
                                    selected.average = 7
                                    selected.counter = try await Counter.fetch(date: .now)
                                    selected.date = .now.toDateWithoutTime ?? .now
                                    sensory.feedback(feedback: .success)
                                    dismiss()
                                } catch {
                                    alert.error = .fetch
                                    alert.show = true
                                    sensory.feedback(feedback: .error)
                                }
                            }
                        }
                        .accessibilityIdentifier("ResetConfirmationDialogButton")
                    }
                    .accessibilityIdentifier("ResetButton")
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel) {
                        showCountersSheet = false
                    }
                    .accessibilityIdentifier("CloseCountersButton")
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

#Preview("CountersView") {
    CountersView(
        selected: Selected(),
        showCountersSheet: .constant(true)
    ) {}
    .environment(Alert())
    .environment(Sensory())
    .modelContainer(
        for: [Counter.self],
        inMemory: true
    )
}
