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
    @Query(sort: \Counter.date,
           order: .reverse) private var counters: [Counter]
    @State private var selected = Selected()
    @State private var showSettingsSheet = false
    @State private var state: States = .isLoading
    private let settingsTip = SettingsTip()
    private var redactedReason: RedactionReasons {
        state == .isLoading ? .placeholder : []
    }

    // MARK: - Layouts

    var body: some View {
        ZStack {
            switch state {
            case .empty:
                ContentUnavailableView {
                    Label("EmptyCounter",
                          systemImage: "plus")
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
                    .textCase(.uppercase)
                    .font(.system(.subheadline,
                                  weight: .black))
                    .accessibilityIdentifier("InsertButton")
                }
                .symbolEffect(.bounce,
                              options: .nonRepeating)
            default:
                let count = selected.counter?.count ?? .zero

                Text(count.description)
                    .font(.system(size: 1000))
                    .minimumScaleFactor(0.001)
                    .lineLimit(1)
                    .opacity(0.25)
                    .padding()
                    .contentTransition(.numericText())
                    .accessibilityIdentifier("CountText")

                HStack {
                    Button("Minus") {
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
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(count <= .zero)
                    .accessibilityIdentifier("MinusButton")

                    Button("Plus") {
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
                    }
                    .frame(maxWidth: .infinity)
                    .accessibilityIdentifier("PlusButton")
                }
                .frame(maxHeight: .infinity)
                .buttonRepeatBehavior(.enabled)
                .font(.system(size: 140.0))
            }
        }
        .ignoresSafeArea(.all)
        .overlay(alignment: .topTrailing) {
            Text(selected.date.toRelative)
                .font(.system(size: 8))
                .padding(.trailing)
                .accessibilityIdentifier("DateText")
        }
        .overlay(alignment: .bottom) {
            Button("Settings") {
                showSettingsSheet = true
                settingsTip.invalidate(reason: .actionPerformed)
            }
            .padding(.bottom)
            .popoverTip(settingsTip)
            .onAppear {
                SettingsTip.show = true
            }
            .accessibilityIdentifier("SettingsButton")
        }
        .sheet(isPresented: $showSettingsSheet) {
            SettingsView(selected: selected)
        }
        .disabled(redactedReason == .placeholder)
        .fontWeight(.bold)
        .monospaced()
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
                            return state = .empty
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
        .modelContainer(for: [Counter.self],
                        inMemory: true)
}
