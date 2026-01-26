//
//  CountersListItem.swift
//  BobbysCounter
//
//  Created by Burak Erol on 23.06.25.
//

import SwiftUI

struct CountersListItem: View {
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
            sensory.feedback(feedback: .selection)
            if counter == selected.counter {
                dismiss()
            } else {
                selected.date = date
            }
        } label: {
            HStack(spacing: 20) {
                Text(counter.date?.toRelative ?? "")

                Spacer()

                Text(counter.count.description)
                    .monospaced()
                    .fontWeight(.black)
                    .lineLimit(1)
            }
        }
        .contextMenu {
            DeleteButton(counter: counter)
        }
        .swipeActions(
            edge: .trailing,
            allowsFullSwipe: true
        ) {
            DeleteButton(counter: counter)
        }
        .confirmationDialog(
            "DeleteCounterConfirmationDialog",
            isPresented: $showDeleteConfirmationDialog,
            titleVisibility: .visible
        ) {
            Button(role: .destructive) {
                guard let counterDelete else {
                    return
                }
                Task {
                    try await CategoryActor.shared.delete(ids: [counterDelete.persistentModelID])
                    sensory.feedback(feedback: .success)
                    if counterDelete == selected.counter {
                        selected.counter = nil
                        dismiss()
                    }
                }
            }
            .accessibilityIdentifier("DeleteCounterConfirmationDialogButton")
        }
        .accessibilityIdentifier("CountersListItem")
    }

    private func DeleteButton(counter: Counter) -> some View {
        Button(
            "Delete",
            systemImage: "trash"
        ) {
            counterDelete = counter
            showDeleteConfirmationDialog = true
            sensory.feedback(feedback: .press(.button))
        }
        .tint(.red)
        .accessibilityIdentifier("DeleteButton")
    }
}

#Preview("CountersListItem") {
    NavigationStack {
        List {
            CountersListItem(
                selected: Selected(),
                counter: Counter(
                    count: .zero,
                    date: .now
                )
            ) {}
            .environment(Alert())
            .environment(Sensory())
        }
    }
}
