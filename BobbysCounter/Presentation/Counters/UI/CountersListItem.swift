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
                    .font(
                        .system(
                            .callout,
                            weight: .black
                        )
                    )
                    .monospacedDigit()
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
                .accessibilityIdentifier(Accessibility.deleteCounterButtonSwipeAction.id)
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
                    try await Counter.delete(ids: [counterDelete.id])
                    sensory.feedback(feedback: .success)
                    if counterDelete == selected.counter {
                        selected.counter = nil
                    }
                }
            }
            .accessibilityIdentifier(Accessibility.deleteCounterButtonConfirmationDialog.id)
        }
        .accessibilityIdentifier(Accessibility.countersListItem.id)
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
    }
}

#Preview("CountersListItem") {
    NavigationStack {
        List {
            CountersListItem(
                selected: Selected(),
                counter: .preview
            ) {}
            .environment(Alert())
            .environment(Sensory())
        }
    }
}
