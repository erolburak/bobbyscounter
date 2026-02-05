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
    @State private var categoryAlertTitle: String = ""
    @State private var selected = Selected()
    @State private var showCategoryAlert = false
    @State private var showSettingsSheet = false
    @State private var state: States = .isLoading
    private let settingsTip = SettingsTip()
    private var isCategoryAlertDisabled: Bool {
        categoryAlertTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    private var isDecrementDisabled: Bool {
        guard let counter = selected.counter else {
            return false
        }
        return !selected.decrementNegative && counter.count - selected.step.rawValue < .zero
    }
    private var redactedReason: RedactionReasons {
        state == .isLoading ? .placeholder : []
    }

    // MARK: - Layouts

    var body: some View {
        NavigationStack {
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
                        Button("Add") {
                            showCategoryAlert = true
                        }
                        .buttonStyle(.glass)
                        .font(
                            .system(
                                .subheadline,
                                weight: .bold
                            )
                        )
                        .textCase(.uppercase)
                        .accessibilityIdentifier(Accessibility.showCategoryAddButton.id)
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
                        Button("Add") {
                            Task {
                                do {
                                    guard let categoryID = selected.category?.persistentModelID
                                    else {
                                        throw Errors.addCounter
                                    }
                                    sensory.feedback(.impact)
                                    selected.counter = try await Counter.add(
                                        categoryID: categoryID,
                                        date: selected.date
                                    )
                                } catch {
                                    sensory.feedback(.error)
                                    alert.error = .addCounter
                                    alert.show = true
                                }
                            }
                        }
                        .buttonStyle(.glass)
                        .font(
                            .system(
                                .subheadline,
                                weight: .bold
                            )
                        )
                        .textCase(.uppercase)
                        .accessibilityIdentifier(Accessibility.addCounterButton.id)
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
                        .font(
                            .system(
                                size: 1000,
                                weight: .black
                            )
                        )
                        .monospacedDigit()
                        .minimumScaleFactor(0.001)
                        .lineLimit(1)
                        .opacity(0.25)
                        .contentTransition(.numericText())
                        .overlay(alignment: .bottom) {
                            HStack {
                                Button {
                                    withAnimation {
                                        do {
                                            sensory.feedback(.decrease)
                                            try selected.counter?.decrement()
                                        } catch {
                                            sensory.feedback(.error)
                                            alert.error = .decrement
                                            alert.show = true
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
                                            sensory.feedback(.increase)
                                            try selected.counter?.increment()
                                        } catch {
                                            sensory.feedback(.error)
                                            alert.error = .increment
                                            alert.show = true
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
                            .font(
                                .system(
                                    size: 80,
                                    weight: .bold
                                )
                            )
                            .labelStyle(.iconOnly)
                            .padding()
                            .padding(.bottom, verticalSizeClass == .compact ? 0 : 120)
                        }
                        .accessibilityIdentifier(Accessibility.countText.id)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationSubtitle(selected.date.toRelative)
            .toolbar {
                ToolbarItem(placement: .title) {
                    Text(selected.category?.title ?? String(localized: "EmptyCategoryAddTitle"))
                        .font(
                            .system(
                                .caption,
                                weight: .semibold
                            )
                        )
                        .onTapGesture {
                            sensory.feedback(.impact)
                        }
                }

                ToolbarItem(placement: .bottomBar) {
                    Button("Settings") {
                        showSettingsSheet = true
                        settingsTip.invalidate(reason: .actionPerformed)
                    }
                    .popoverTip(settingsTip)
                    .onAppear {
                        SettingsTip.show = true
                    }
                    .accessibilityIdentifier(Accessibility.settingsButton.id)
                }
            }
            .toolbarTitleMenu {
                Button(
                    "AddCategory",
                    systemImage: "square.stack.3d.down.right"
                ) {
                    showCategoryAlert = true
                }

                Picker(
                    selected.category?.title ?? "EmptyCategoryAddTitle",
                    selection: $selected.category
                ) {
                    ForEach(categories) {
                        Text($0.title ?? "")
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
                        let categoryID = try await Category.add(
                            decrementNegative: selected.decrementNegative,
                            step: selected.step,
                            title: categoryAlertTitle
                        )
                        selected.category = categories.first {
                            $0.persistentModelID == categoryID
                        }
                        categoryAlertTitle.removeAll()
                    } catch {
                        sensory.feedback(.error)
                        categoryAlertTitle.removeAll()
                        alert.error = .addCategory
                        alert.show = true
                    }
                }
            }
            .disabled(isCategoryAlertDisabled)
            .accessibilityIdentifier(Accessibility.categoryAlertConfirmButton.id)

            Button(role: .cancel) {
                categoryAlertTitle.removeAll()
            }
        }
        .disabled(redactedReason == .placeholder)
        .redacted(reason: redactedReason)
        .onChange(of: selected.category) {
            sensory.feedback(.selection)
            refresh()
        }
        .onChange(of: selected.counter) {
            refresh()
        }
        .onChange(of: showCategoryAlert) {
            sensory.feedback(.impact)
        }
        .onChange(of: showSettingsSheet) {
            sensory.feedback(.impact)
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
        .onOpenURL { url in
            let urlComponents = URLComponents(
                url: url,
                resolvingAgainstBaseURL: false
            )
            guard
                let categoryTitle = urlComponents?.queryItems?.first(where: { $0.name == "title" })?
                    .value
            else {
                sensory.feedback(.error)
                alert.error = .fetchWidget
                alert.show = true
                return
            }
            selected.category = categories.first { $0.title == categoryTitle }
            selected.date = .now
        }
    }

    private func refresh() {
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
            guard let categoryID = selected.category?.id else {
                withAnimation {
                    state = .emptyCategory
                }
                return
            }
            do {
                guard
                    let counter = try await Counter.fetch(
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
                sensory.feedback(.error)
                alert.error = .fetch
                alert.show = true
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
