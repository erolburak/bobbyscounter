//
//  CategoriesView.swift
//  BobbysCounter
//
//  Created by Burak Erol on 26.01.26.
//

import SwiftData
import SwiftUI

struct CategoriesView: View {
    // MARK: - Private Properties

    @Environment(Alert.self) private var alert
    @Environment(Sensory.self) private var sensory
    @Query(
        sort: \Category.title,
        order: .forward
    ) private var categories: [Category]
    @State private var showDeleteConfirmationDialog = false
    private var categoriesWithoutSelectedCategory: [Category] {
        categories.lazy.filter { $0.title != selected.category?.title }
    }

    // MARK: - Properties

    @Bindable var selected: Selected
    @Binding var showCategoriesSheet: Bool
    let dismiss: () -> Void

    // MARK: - Layouts

    var body: some View {
        NavigationStack {
            Group {
                if !categories.isEmpty {
                    List {
                        if let category = selected.category {
                            Section {
                                CategoriesListItem(
                                    selected: selected,
                                    category: category,
                                    dismiss: dismiss
                                )
                            } header: {
                                Text("SelectedCategory")
                            }
                        }

                        if !categoriesWithoutSelectedCategory.isEmpty {
                            Section {
                                ForEach(categoriesWithoutSelectedCategory) { category in
                                    CategoriesListItem(
                                        selected: selected,
                                        category: category,
                                        dismiss: dismiss
                                    )
                                }
                            } header: {
                                Text("Categories")
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                } else {
                    ContentUnavailableView {
                        Label(
                            "EmptyCategories",
                            systemImage: "square.stack.3d.down.right"
                        )
                    } description: {
                        Text("EmptyCategoriesMessage")
                    }
                    .symbolEffect(
                        .bounce,
                        options: .nonRepeating
                    )
                    .symbolVariant(.fill)
                }
            }
            .navigationTitle("Categories")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button(role: .destructive) {
                        showDeleteConfirmationDialog = true
                    }
                    .disabled(categories.isEmpty)
                    .tint(.red)
                    .confirmationDialog(
                        "DeleteCategoriesConfirmationDialog",
                        isPresented: $showDeleteConfirmationDialog,
                        titleVisibility: .visible
                    ) {
                        Button(
                            "Delete",
                            role: .destructive
                        ) {
                            Task {
                                try await Category.delete(ids: categories.lazy.map(\.id))
                                selected.category = nil
                                dismiss()
                            }
                        }
                        .accessibilityIdentifier(
                            Accessibility.deleteCategoriesButtonConfirmationDialog.id)
                    }
                    .accessibilityIdentifier(Accessibility.deleteCategoriesButton.id)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel) {
                        showCategoriesSheet = false
                    }
                    .accessibilityIdentifier(Accessibility.closeCategoriesButton.id)
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

#Preview("CategoriesView") {
    CategoriesView(
        selected: Selected(),
        showCategoriesSheet: .constant(true)
    ) {}
    .environment(Alert())
    .environment(Sensory())
    .modelContainer(
        for: [Category.self],
        inMemory: true
    )
}
