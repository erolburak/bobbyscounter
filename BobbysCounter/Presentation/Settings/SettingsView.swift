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
                                sensory.feedback(feedback: .press(.button))
                            }
                            .accessibilityIdentifier(Accessibility.categoriesButton.id)

                            Button(
                                "Counters",
                                systemImage: "square.stack.3d.up"
                            ) {
                                showCountersSheet = true
                                sensory.feedback(feedback: .press(.button))
                            }
                            .accessibilityIdentifier(Accessibility.countersButton.id)

                            Button(
                                "Average",
                                systemImage: "divide"
                            ) {
                                showAverageSheet = true
                                sensory.feedback(feedback: .press(.button))
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
                                sensory.feedback(feedback: .press(.button))
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
                        sensory.feedback(feedback: .press(.button))
                        dismiss()
                    }
                    .accessibilityIdentifier(Accessibility.closeSettingsButton.id)
                }

                ToolbarItem(placement: .bottomBar) {
                    Button("Today") {
                        withAnimation {
                            selected.date = .now.toDateWithoutTime ?? .now
                            sensory.feedback(feedback: .selection)
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
                        try await Category.delete(ids: categories.lazy.map(\.id))
                        selected.average = 7
                        selected.category = nil
                        selected.counter = nil
                        selected.date = .now
                        selected.decrementNegative = false
                        selected.step = .one
                        sensory.feedback(feedback: .success)
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
                            sensory.feedback(feedback: .press(.button))
                        } catch {
                            alert.error = .resetCount
                            alert.show = true
                            sensory.feedback(feedback: .error)
                        }
                    }
                }

                Button(role: .cancel) {
                    showCountResetAlert = false
                    sensory.feedback(feedback: .press(.button))
                }
            }
            .onChange(of: selected.date) { _, newValue in
                Task {
                    do {
                        guard let categoryID = selected.category?.id else {
                            return
                        }
                        selected.counter = try await Counter.fetch(
                            categoryID: categoryID,
                            date: newValue
                        )
                        sensory.feedback(feedback: .selection)
                        dismiss()
                    } catch {
                        alert.error = .fetch
                        alert.show = true
                        sensory.feedback(feedback: .error)
                    }
                }
            }
            .onChange(of: selected.decrementNegative) { _, newValue in
                do {
                    try selected.category?.decrementNegative(newValue)
                    sensory.feedback(feedback: .press(.toggle))
                } catch {
                    alert.error = .decrementNegative
                    alert.show = true
                    sensory.feedback(feedback: .error)
                }
                if let count = selected.counter?.count,
                    count < .zero,
                    !newValue
                {
                    showCountResetAlert = true
                    sensory.feedback(feedback: .warning)
                }
            }
            .onChange(of: selected.step) { _, newValue in
                do {
                    try selected.category?.step(newValue)
                    sensory.feedback(feedback: .selection)
                } catch {
                    alert.error = .step
                    alert.show = true
                    sensory.feedback(feedback: .error)
                }
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
