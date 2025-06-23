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

    @Environment(\.scenePhase) private var scenePhase
    @Environment(Alert.self) private var alert
    @Environment(Sensory.self) private var sensory
    @Query(
        sort: \Counter.date,
        order: .reverse
    ) private var counters: [Counter]
    @State private var selected = Selected()
    @State private var showSettingsSheet = false
    @State private var state: States = .isLoading
    private let settingsTip = SettingsTip()
    private var redactedReason: RedactionReasons {
        state == .isLoading ? .placeholder : []
    }

    // MARK: - Layouts

    var body: some View {
        NavigationStack {
            Group {
                switch state {
                case .empty:
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
                                    selected.counter = try await Counter.insert(date: selected.date)
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
                        .accessibilityIdentifier("InsertButton")
                    }
                    .symbolEffect(
                        .bounce,
                        options: .nonRepeating
                    )
                    .symbolVariant(.fill)
                default:
                    let count = selected.counter?.count ?? .zero

                    Text(count.description)
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
                        .overlay {
                            HStack {
                                Button {
                                    withAnimation {
                                        do {
                                            try selected.counter?.decrease()
                                            sensory.feedback(feedback: .decrease)
                                        } catch {
                                            alert.error = .decrease
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
                                .disabled(count <= .zero)

                                Spacer()

                                Button {
                                    withAnimation {
                                        do {
                                            try selected.counter?.increase()
                                            sensory.feedback(feedback: .increase)
                                        } catch {
                                            alert.error = .increase
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
                        }
                        .accessibilityIdentifier("CountText")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .title) {
                    Text(selected.date.toRelative)
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
        }
        .sheet(isPresented: $showSettingsSheet) {
            SettingsView(selected: selected)
        }
        .disabled(redactedReason == .placeholder)
        .redacted(reason: redactedReason)
        .onChange(of: selected.counter) { _, newValue in
            withAnimation {
                state = newValue == nil ? .empty : .loaded
            }
        }
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .active:
                Task {
                    do {
                        guard let counter = try await Counter.fetch(date: selected.date) else {
                            state = .empty
                            return
                        }
                        selected.counter = counter
                    } catch {
                        alert.error = .fetch
                        alert.show = true
                        sensory.feedback(feedback: .error)
                    }
                }
            case .background:
                WidgetCenter.shared.reloadAllTimelines()
            default:
                break
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(Alert())
        .environment(Sensory())
        .modelContainer(
            for: [Counter.self],
            inMemory: true
        )
}
