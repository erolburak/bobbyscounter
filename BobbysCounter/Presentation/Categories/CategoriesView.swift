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
    @State private var showResetConfirmationDialog = false
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
                        showResetConfirmationDialog = true
                        sensory.feedback(feedback: .press(.button))
                    }
                    .tint(.red)
                    .confirmationDialog(
                        "ResetCategoriesConfirmationDialog",
                        isPresented: $showResetConfirmationDialog,
                        titleVisibility: .visible
                    ) {
                        Button(
                            "Reset",
                            role: .destructive
                        ) {
                            Task {
                                try await CategoryActor.shared.delete(
                                    ids: categories.lazy.map(\.persistentModelID)
                                )
                                sensory.feedback(feedback: .success)
                                selected.category = nil
                                dismiss()
                            }
                        }
                        .accessibilityIdentifier("ResetCategoriesConfirmationDialogButton")
                    }
                    .accessibilityIdentifier("ResetButton")
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel) {
                        showCategoriesSheet = false
                    }
                    .accessibilityIdentifier("CloseCategoriesButton")
                }
            }
        }
        .presentationDetents([.medium, .large])
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
