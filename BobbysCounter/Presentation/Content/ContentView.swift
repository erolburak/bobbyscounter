//
//  ContentView.swift
//  BobbysCounter
//
//  Created by Burak Erol on 27.06.23.
//

import SwiftData
import SwiftUI
import WidgetKit

struct ContentView: View {
    // MARK: - Private Properties

    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.scenePhase) private var scenePhase
    @Environment(Alert.self) private var alert
    @Environment(Sensory.self) private var sensory
    @Query(
        sort: \Category.title,
        order: .forward
    ) private var categories: [Category]
    @State private var categoryInsertAlertTitle: String = ""
    @State private var selected = Selected()
    @State private var showCategoryInsertAlert = false
    @State private var showSettingsSheet = false
    @State private var state: States = .isLoading
    private let settingsTip = SettingsTip()
    private var isDecrementDisabled: Bool {
        guard let counter = selected.counter else {
            return false
        }
        return !selected.decrementNegative && counter.count - selected.step.rawValue < .zero
    }
    private var isCategoryInsertAlertDisabled: Bool {
        categoryInsertAlertTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    private var redactedReason: RedactionReasons {
        state == .isLoading ? .placeholder : []
    }

    // MARK: - Layouts

    var body: some View {
        NavigationStack {
            Text(foo.description)
                .font(.headline)
            Group {
                switch state {
                case .emptyCategory:
                    ContentUnavailableView {
                        Label(
                            "EmptyCategories",
                            systemImage: "plus"
                        )
                    } description: {
                        Text("EmptyCategoriesMessage")
                    } actions: {
                        Button("Insert") {
                            showCategoryInsertAlert = true
                            sensory.feedback(feedback: .press(.button))
                        }
                        .buttonStyle(.glass)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                        .accessibilityIdentifier("ShowCategoryInsertButton")
                    }
                    .symbolEffect(
                        .bounce,
                        options: .nonRepeating
                    )
                    .symbolVariant(.fill)
                case .emptyCounter:
                    ContentUnavailableView {
                        Label(
                            "EmptyCounter",
                            systemImage: "plus"
                        )
                    } description: {
                        Text("EmptyCounterMessage")
                    } actions: {
                        Button("Insert") {
                            Task {
                                do {
                                    guard let categoryID = selected.category?.persistentModelID
                                    else {
                                        throw Errors.insert
                                    }
                                    selected.counter = try await Category.insertCounter(
                                        categoryID: categoryID,
                                        date: selected.date
                                    )
                                    sensory.feedback(feedback: .success)
                                } catch {
                                    alert.error = .insert
                                    alert.show = true
                                    sensory.feedback(feedback: .error)
                                }
                            }
                        }
                        .buttonStyle(.glass)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                        .accessibilityIdentifier("InsertCounterButton")
                    }
                    .symbolEffect(
                        .bounce,
                        options: .nonRepeating
                    )
                    .symbolVariant(.fill)
                default:
                    Text((selected.counter?.count ?? .zero).description)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity
                        )
                        .monospaced()
                        .font(.system(size: 1000))
                        .fontWeight(.black)
                        .minimumScaleFactor(0.001)
                        .lineLimit(1)
                        .opacity(0.25)
                        .contentTransition(.numericText())
                        .overlay(alignment: .bottom) {
                            HStack {
                                Button {
                                    withAnimation {
                                        do {
                                            try selected.counter?.decrement(selected.step)
                                            sensory.feedback(feedback: .decrease)
                                        } catch {
                                            alert.error = .decrement
                                            alert.show = true
                                            sensory.feedback(feedback: .error)
                                        }
                                    }
                                } label: {
                                    Label(
                                        "Minus",
                                        systemImage: "minus"
                                    )
                                    .frame(minHeight: 80)
                                }
                                .disabled(isDecrementDisabled)

                                Spacer()

                                Button {
                                    withAnimation {
                                        do {
                                            try selected.counter?.increment(selected.step)
                                            sensory.feedback(feedback: .increase)
                                        } catch {
                                            alert.error = .increment
                                            alert.show = true
                                            sensory.feedback(feedback: .error)
                                        }
                                    }
                                } label: {
                                    Label(
                                        "Plus",
                                        systemImage: "plus"
                                    )
                                    .frame(minHeight: 80)
                                }
                            }
                            .buttonStyle(.glass)
                            .buttonRepeatBehavior(.enabled)
                            .font(.system(size: 80))
                            .fontWeight(.bold)
                            .labelStyle(.iconOnly)
                            .padding()
                            .padding(.bottom, verticalSizeClass == .compact ? 0 : 120)
                        }
                        .accessibilityIdentifier("CountText")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationSubtitle(selected.date.toRelative)
            .toolbar {
                ToolbarItem(placement: .title) {
                    Text(selected.category?.title ?? String(localized: "EmptyCategoryInsertTitle"))
                        .font(.caption)
                        .fontWeight(.semibold)
                        .accessibilityIdentifier("DateText")
                }

                ToolbarItem(placement: .bottomBar) {
                    Button("Settings") {
                        showSettingsSheet = true
                        settingsTip.invalidate(reason: .actionPerformed)
                        sensory.feedback(feedback: .press(.button))
                    }
                    .popoverTip(settingsTip)
                    .onAppear {
                        SettingsTip.show = true
                    }
                    .accessibilityIdentifier("SettingsButton")
                }
            }
            .toolbarTitleMenu {
                Button("InsertCategory") {
                    showCategoryInsertAlert = true
                }

                Picker(
                    selected.category?.title ?? "EmptyCategoryInsertTitle",
                    selection: $selected.category
                ) {
                    ForEach(categories) {
                        Button($0.title ?? "") {
                            sensory.feedback(feedback: .selection)
                        }
                        .tag($0)
                    }
                }
                .pickerStyle(.automatic)
            }
        }
        .sheet(isPresented: $showSettingsSheet) {
            SettingsView(selected: selected)
        }
        .alert(
            "CategoryInsertAlert",
            isPresented: $showCategoryInsertAlert
        ) {
            TextField(
                "CategoryAlertTitlePlaceholder",
                text: $categoryInsertAlertTitle
            )

            Button(role: .confirm) {
                Task {
                    do {
                        let categoryID = try await Category.insertCategory(
                            decrementNegative: selected.decrementNegative,
                            step: selected.step,
                            title: categoryInsertAlertTitle
                        )
                        selected.category = categories.first { $0.persistentModelID == categoryID }
                        categoryInsertAlertTitle.removeAll()
                        sensory.feedback(feedback: .press(.button))
                    } catch {
                        categoryInsertAlertTitle.removeAll()
                        alert.error = .categoryDuplicate
                        alert.show = true
                        sensory.feedback(feedback: .error)
                    }
                }
            }
            .disabled(isCategoryInsertAlertDisabled)
            .accessibilityIdentifier("CategoryInsertAlertButton")

            Button(role: .cancel) {
                sensory.feedback(feedback: .press(.button))
            }
        }
        .disabled(redactedReason == .placeholder)
        .redacted(reason: redactedReason)
        .onChange(of: selected.category) {
            refresh()
        }
        .onChange(of: selected.counter) {
            refresh()
        }
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .active:
                refresh()
            case .background:
                WidgetCenter.shared.reloadAllTimelines()
            default:
                break
            }
        }
    }

    @State private var foo = 0

    private func refresh() {
        foo += 1
        Task {
            withAnimation {
                if selected.category == nil {
                    guard let category = categories.first else {
                        state = .emptyCategory
                        return
                    }
                    selected.category = category
                }
            }
            guard let categoryID = selected.category?.persistentModelID else {
                withAnimation {
                    state = .emptyCategory
                }
                return
            }
            do {
                guard
                    let counter = try await Category.fetchCounter(
                        categoryID: categoryID,
                        date: selected.date
                    )
                else {
                    withAnimation {
                        state = .emptyCounter
                    }
                    return
                }
                withAnimation {
                    selected.counter = counter
                }
            } catch {
                alert.error = .fetch
                alert.show = true
                sensory.feedback(feedback: .error)
            }
            withAnimation {
                selected.decrementNegative = selected.category?.decrementNegative ?? false
                selected.step = selected.category?.step ?? .one
                state =
                    if categories.isEmpty {
                        .emptyCategory
                    } else if selected.counter == nil {
                        .emptyCounter
                    } else {
                        .loaded
                    }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(Alert())
        .environment(Sensory())
        .modelContainer(
            for: [Category.self],
            inMemory: true
        )
}
