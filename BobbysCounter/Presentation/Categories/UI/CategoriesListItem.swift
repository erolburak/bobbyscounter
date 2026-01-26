//
//  CategoriesListItem.swift
//  BobbysCounter
//
//  Created by Burak Erol on 26.01.26.
//

import SwiftUI

struct CategoriesListItem: View {
    // MARK: - Private Properties

    @Environment(Alert.self) private var alert
    @Environment(Sensory.self) private var sensory
    @State private var categoryDelete: Category?
    @State private var categoryEditAlertTitle: String = ""
    @State private var showCategoryEditAlert = false
    @State private var showDeleteConfirmationDialog = false
    private var isCategoryEditAlertDisabled: Bool {
        categoryEditAlertTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || category.title == categoryEditAlertTitle
    }

    // MARK: - Properties

    @Bindable var selected: Selected
    let category: Category
    let dismiss: () -> Void

    // MARK: - Layouts

    var body: some View {
        Button {
            sensory.feedback(feedback: .selection)
            selected.category = category
            dismiss()
        } label: {
            HStack(spacing: 20) {
                Text(category.title ?? "")

                Spacer()

                Text(category.counters?.count.description ?? "0")
                    .monospaced()
                    .fontWeight(.black)
                    .lineLimit(1)
            }
        }
        .contextMenu {
            EditButton(category: category)
            DeleteButton(category: category)
        }
        .swipeActions(
            edge: .trailing,
            allowsFullSwipe: true
        ) {
            EditButton(category: category)

            DeleteButton(category: category)
        }
        .confirmationDialog(
            "DeleteCategoryConfirmationDialog",
            isPresented: $showDeleteConfirmationDialog,
            titleVisibility: .visible
        ) {
            Button(role: .destructive) {
                guard let categoryDelete else {
                    return
                }
                Task {
                    try await CategoryActor.shared.delete(ids: [categoryDelete.persistentModelID])
                    sensory.feedback(feedback: .success)
                    if categoryDelete == selected.category {
                        selected.category = nil
                        dismiss()
                    }
                }
            }
            .accessibilityIdentifier("DeleteCategoryConfirmationDialogButton")
        }
        .alert(
            "CategoryEditAlert",
            isPresented: $showCategoryEditAlert
        ) {
            TextField(
                "CategoryAlertTitlePlaceholder",
                text: $categoryEditAlertTitle
            )

            Button(role: .confirm) {
                Task {
                    do {
                        try category.edit(title: categoryEditAlertTitle)
                        sensory.feedback(feedback: .press(.button))
                    } catch {
                        categoryEditAlertTitle = category.title ?? ""
                        alert.error = .categoryEdit
                        alert.show = true
                        sensory.feedback(feedback: .error)
                    }
                }
            }
            .disabled(isCategoryEditAlertDisabled)
            .accessibilityIdentifier("CategoryEditAlertButton")

            Button(role: .cancel) {
                sensory.feedback(feedback: .press(.button))
            }
        }
        .onAppear {
            categoryEditAlertTitle = category.title ?? ""
        }
        .accessibilityIdentifier("CategoriesListItem")
    }

    private func DeleteButton(category: Category) -> some View {
        Button(
            "Delete",
            systemImage: "trash"
        ) {
            categoryDelete = category
            showDeleteConfirmationDialog = true
            sensory.feedback(feedback: .press(.button))
        }
        .tint(.red)
        .accessibilityIdentifier("DeleteButton")
    }

    private func EditButton(category: Category) -> some View {
        Button(
            "Edit",
            systemImage: "pencil"
        ) {
            showCategoryEditAlert = true
            sensory.feedback(feedback: .press(.button))
        }
        .accessibilityIdentifier("EditButton")
    }
}

#Preview("CategoriesListItem") {
    NavigationStack {
        List {
            CategoriesListItem(
                selected: Selected(),
                category: Category(
                    counters: [
                        Counter(
                            count: .zero,
                            date: .now
                        )
                    ],
                    decrementNegative: false,
                    step: .one,
                    title: "Title"
                )
            ) {}
            .environment(Alert())
            .environment(Sensory())
        }
    }
}
