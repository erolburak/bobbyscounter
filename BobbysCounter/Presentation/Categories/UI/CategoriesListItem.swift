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
    @State private var categoryAlertTitle: String = ""
    @State private var categoryDelete: Category?
    @State private var showCategoryAlert = false
    @State private var showDeleteConfirmationDialog = false
    private var categoryAlertDisabled: Bool {
        categoryAlertTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || category.title == categoryAlertTitle
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
            EditButton(category: category)

            DeleteButton(category: category)
        }
        .swipeActions(
            edge: .trailing,
            allowsFullSwipe: true
        ) {
            EditButton(category: category)

            DeleteButton(category: category)
                .accessibilityIdentifier(Accessibility.deleteCategoryButtonSwipeAction.id)
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
                    try await Category.delete(ids: [categoryDelete.persistentModelID])
                    sensory.feedback(feedback: .success)
                    if categoryDelete == selected.category {
                        selected.category = nil
                    }
                }
            }
            .accessibilityIdentifier(Accessibility.deleteCategoryButtonConfirmationDialog.id)
        }
        .alert(
            "CategoryAlert",
            isPresented: $showCategoryAlert
        ) {
            TextField(
                "CategoryAlertPlaceholder",
                text: $categoryAlertTitle
            )

            Button(role: .confirm) {
                Task {
                    do {
                        try category.edit(title: categoryAlertTitle)
                        sensory.feedback(feedback: .press(.button))
                    } catch {
                        categoryAlertTitle = category.title ?? ""
                        alert.error = .editCategory
                        alert.show = true
                        sensory.feedback(feedback: .error)
                    }
                }
            }
            .disabled(categoryAlertDisabled)
            .accessibilityIdentifier(Accessibility.categoryAlertConfirmButton.id)

            Button(role: .cancel) {
                sensory.feedback(feedback: .press(.button))
            }
        }
        .onAppear {
            categoryAlertTitle = category.title ?? ""
        }
        .accessibilityIdentifier(Accessibility.categoriesListItem.id)
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
    }

    private func EditButton(category: Category) -> some View {
        Button(
            "Edit",
            systemImage: "pencil"
        ) {
            showCategoryAlert = true
            sensory.feedback(feedback: .press(.button))
        }
        .accessibilityIdentifier(Accessibility.editButton.id)
    }
}

#Preview("CategoriesListItem") {
    NavigationStack {
        List {
            CategoriesListItem(
                selected: Selected(),
                category: .preview
            ) {}
            .environment(Alert())
            .environment(Sensory())
        }
    }
}
