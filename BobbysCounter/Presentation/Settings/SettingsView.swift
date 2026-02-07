//
//  SettingsView.swift
//  BobbysCounter
//
//  Created by Burak Erol on 18.07.23.
//

import SwiftData
import SwiftUI

struct SettingsView: View {
    // MARK: - Private Properties

    @Environment(\.dismiss) private var dismiss
    @Environment(Alert.self) private var alert
    @Environment(Sensory.self) private var sensory
    @Query(
        sort: \Category.title,
        order: .forward
    ) private var categories: [Category]
    @State private var showAverageSheet = false
    @State private var showCategoriesSheet = false
    @State private var showCountersSheet = false
    @State private var showCountResetAlert = false
    @State private var showResetConfirmationDialog = false
    private var counters: [Counter] {
        selected.category?.countersSorted ?? []
    }
    private var presentationDetent: PresentationDetent {
        counters.isEmpty ? .fraction(0.75) : .medium
    }

    // MARK: - Properties

    @Bindable var selected: Selected

    // MARK: - Layouts

    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    DatePicker(
                        "SelectedDate",
                        selection: $selected.date,
                        in: ...Date.now,
                        displayedComponents: [.date]
                    )
                    .disabled(selected.category == nil)
                    .datePickerStyle(.compact)
                    .accessibilityIdentifier(Accessibility.datePicker.id)

                    Toggle(isOn: $selected.decrementNegative) {
                        Text("DecrementNegative")
                    }
                    .accessibilityIdentifier(Accessibility.decrementNegativeToggle.id)

                    LabeledContent("SelectedStep") {
                        Picker(selection: $selected.step) {
                            ForEach(
                                Steps.allCases,
                                id: \.self
                            ) {
                                Text($0.rawValue.description)
                                    .tag($0)
                            }
                        } label: {
                            EmptyView()
                        }
                        .accessibilityIdentifier(Accessibility.stepsPicker.id)
                    }
                }
                .padding()

                if !counters.isEmpty {
                    ChartView(selected: selected)
                } else {
                    ContentUnavailableView {
                        Label(
                            "EmptyCharts",
                            systemImage: "chart.xyaxis.line"
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

                Spacer()
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        ControlGroup {
                            Button(
                                "Categories",
                                systemImage: "square.stack.3d.down.right"
                            ) {
                                showCategoriesSheet = true
                            }
                            .accessibilityIdentifier(Accessibility.categoriesButton.id)

                            Button(
                                "Counters",
                                systemImage: "square.stack.3d.up"
                            ) {
                                showCountersSheet = true
                            }
                            .accessibilityIdentifier(Accessibility.countersButton.id)

                            Button(
                                "Average",
                                systemImage: "divide"
                            ) {
                                showAverageSheet = true
                            }
                            .accessibilityIdentifier(Accessibility.averageButton.id)
                        }

                        Section {
                            Button(
                                "Reset",
                                systemImage: "trash",
                                role: .destructive
                            ) {
                                showResetConfirmationDialog = true
                            }
                            .accessibilityIdentifier(Accessibility.resetButton.id)
                        }
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityIdentifier(Accessibility.settingsMenu.id)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close) {
                        dismiss()
                    }
                    .accessibilityIdentifier(Accessibility.closeSettingsButton.id)
                }

                ToolbarItem(placement: .bottomBar) {
                    Button("Today") {
                        withAnimation {
                            selected.date = .now.toDateWithoutTime ?? .now
                        }
                    }
                    .disabled(selected.date.isDateToday)
                    .accessibilityIdentifier(Accessibility.todayButton.id)
                }
            }
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
                        try await Category.delete(ids: categories.lazy.map(\.persistentModelID))
                        selected.average = 7
                        selected.category = nil
                        selected.counter = nil
                        selected.date = .now
                        selected.decrementNegative = false
                        selected.step = .one
                        dismiss()
                    }
                }
                .accessibilityIdentifier(Accessibility.resetButtonConfirmationDialog.id)
            }
            .sheet(isPresented: $showAverageSheet) {
                AverageView(
                    selected: selected,
                    showAverageSheet: $showAverageSheet
                )
            }
            .sheet(isPresented: $showCategoriesSheet) {
                CategoriesView(
                    selected: selected,
                    showCategoriesSheet: $showCategoriesSheet
                ) {
                    dismiss()
                }
            }
            .sheet(isPresented: $showCountersSheet) {
                CountersView(
                    selected: selected,
                    showCountersSheet: $showCountersSheet
                ) {
                    dismiss()
                }
            }
            .alert(
                "ResetCountTitle",
                isPresented: $showCountResetAlert
            ) {
                Button(
                    "Reset",
                    role: .destructive
                ) {
                    withAnimation {
                        do {
                            try selected.counter?.resetCount()
                        } catch {
                            sensory.feedback(.error)
                            alert.error = .resetCount
                            alert.show = true
                        }
                    }
                }

                Button(role: .cancel) {
                    showCountResetAlert = false
                }
            }
            .onChange(of: selected.date) { _, newValue in
                Task {
                    do {
                        guard let categoryID = selected.category?.persistentModelID else {
                            return
                        }
                        selected.counter = try await Counter.fetch(
                            categoryID: categoryID,
                            date: newValue
                        )
                        dismiss()
                    } catch {
                        sensory.feedback(.error)
                        alert.error = .fetch
                        alert.show = true
                    }
                }
            }
            .onChange(of: selected.decrementNegative) { _, newValue in
                do {
                    sensory.feedback(.impact)
                    try selected.category?.decrementNegative(newValue)
                } catch {
                    sensory.feedback(.error)
                    alert.error = .decrementNegative
                    alert.show = true
                }
                if let count = selected.counter?.count,
                    count < .zero,
                    !newValue
                {
                    showCountResetAlert = true
                }
            }
            .onChange(of: selected.step) { _, newValue in
                do {
                    sensory.feedback(.selection)
                    try selected.category?.step(newValue)
                } catch {
                    sensory.feedback(.error)
                    alert.error = .step
                    alert.show = true
                }
            }
            .onChange(of: showAverageSheet) {
                sensory.feedback(.impact)
            }
            .onChange(of: showCategoriesSheet) {
                sensory.feedback(.impact)
            }
            .onChange(of: showCountersSheet) {
                sensory.feedback(.impact)
            }
            .onChange(of: showCountResetAlert) {
                sensory.feedback(.impact)
            }
            .onChange(of: showResetConfirmationDialog) {
                sensory.feedback(.impact)
            }
        }
        .presentationDetents([presentationDetent])
    }
}

#Preview {
    Color
        .clear
        .sheet(isPresented: .constant(true)) {
            SettingsView(selected: Selected())
                .environment(Alert())
                .environment(Sensory())
        }
        .modelContainer(
            for: [Category.self],
            inMemory: true
        )
}
