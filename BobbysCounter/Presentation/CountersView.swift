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
    @Query(sort: \Counter.date,
           order: .reverse) private var counters: [Counter]
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
                                ListItem(selected: selected,
                                         counter: counter,
                                         dismiss: dismiss)
                            } header: {
                                Text("SelectedCounter")
                            }
                        }

                        if !filteredCounters.isEmpty {
                            Section {
                                ForEach(filteredCounters) { counter in
                                    ListItem(selected: selected,
                                             counter: counter,
                                             dismiss: dismiss)
                                }
                            } header: {
                                Text("Counters")
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                } else {
                    ContentUnavailableView("EmptyCounters",
                                           systemImage: "list.bullet.circle.fill",
                                           description: Text("EmptyCountersMessage"))
                        .symbolEffect(.bounce,
                                      options: .nonRepeating)
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
                                        titleVisibility: .visible)
                    {
                        Button("Reset",
                               role: .destructive)
                        {
                            Task {
                                try await CounterActor.shared.delete(ids: counters.lazy.map(\.persistentModelID))
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
                    Button("Close",
                           systemImage: "xmark.circle.fill")
                    {
                        showCountersSheet = false
                    }
                    .accessibilityIdentifier("CloseCountersButton")
                }
            }
        }
    }
}

#Preview("CountersView") {
    CountersView(selected: Selected(),
                 showCountersSheet: .constant(true),
                 dismiss: {})
        .environment(Alert())
        .environment(Sensory())
        .modelContainer(for: [Counter.self],
                        inMemory: true)
}

private struct ListItem: View {
    // MARK: - Private Properties

    @Environment(Alert.self) private var alert
    @Environment(Sensory.self) private var sensory
    @State private var counterDelete: Counter?
    @State private var showDeleteConfirmationDialog = false

    // MARK: - Properties

    @Bindable var selected: Selected
    let counter: Counter
    let dismiss: () -> Void

    // MARK: - Layouts

    var body: some View {
        Button {
            guard let date = counter.date else {
                return
            }
            if counter == selected.counter {
                sensory.feedback(feedback: .selection)
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
                      allowsFullSwipe: true)
        {
            DeleteButton(counter: counter,
                         isContextMenu: false)
        }
        .confirmationDialog("DeleteConfirmationDialog",
                            isPresented: $showDeleteConfirmationDialog,
                            titleVisibility: .visible)
        {
            Button("Delete",
                   role: .destructive)
            {
                guard let counterDelete else {
                    return
                }
                Task {
                    try await CounterActor.shared.delete(ids: [counterDelete.persistentModelID])
                    if counterDelete == selected.counter {
                        do {
                            selected.counter = try await Counter.fetch(date: .now)
                            selected.date = .now.toDateWithoutTime ?? .now
                            sensory.feedback(feedback: .success)
                            dismiss()
                        } catch {
                            alert.error = .fetch
                            alert.show = true
                            sensory.feedback(feedback: .error)
                        }
                    } else {
                        sensory.feedback(feedback: .success)
                    }
                }
            }
            .accessibilityIdentifier("DeleteConfirmationDialogButton")
        }
    }

    private func DeleteButton(counter: Counter,
                              isContextMenu: Bool) -> some View
    {
        Button("Delete",
               systemImage: isContextMenu ? "trash.circle.fill" : "trash")
        {
            counterDelete = counter
            showDeleteConfirmationDialog = true
        }
        .accessibilityIdentifier("DeleteButton")
    }
}

#Preview("ListItem") {
    ListItem(selected: Selected(),
             counter: Counter(count: .zero,
                              date: .now),
             dismiss: {})
        .environment(Alert())
        .environment(Sensory())
        .modelContainer(for: [Counter.self],
                        inMemory: true)
}
