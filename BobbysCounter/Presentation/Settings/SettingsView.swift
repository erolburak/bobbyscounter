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
        sort: \Counter.date,
        order: .reverse
    ) private var counters: [Counter]
    @State private var showAverageSheet = false
    @State private var showCountersSheet = false

    // MARK: - Properties

    @Bindable var selected: Selected

    // MARK: - Layouts

    var body: some View {
        NavigationStack {
            VStack {
                DatePicker(
                    "SelectedDate",
                    selection: $selected.date,
                    in: ...Date.now,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.compact)
                .padding()
                .accessibilityIdentifier("DatePicker")

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
                ToolbarItem(placement: .topBarTrailing) {
                    Button(
                        "Average",
                        systemImage: "divide"
                    ) {
                        showAverageSheet = true
                        sensory.feedback(feedback: .press(.button))
                    }
                    .accessibilityIdentifier("AverageButton")
                }

                ToolbarItem(placement: .primaryAction) {
                    Button(
                        "Counters",
                        systemImage: "list.bullet"
                    ) {
                        showCountersSheet = true
                        sensory.feedback(feedback: .press(.button))
                    }
                    .accessibilityIdentifier("CountersButton")
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close) {
                        sensory.feedback(feedback: .press(.button))
                        dismiss()
                    }
                    .accessibilityIdentifier("CloseSettingsButton")
                }

                ToolbarItem(placement: .bottomBar) {
                    Button("Today") {
                        withAnimation {
                            selected.date = .now.toDateWithoutTime ?? .now
                            sensory.feedback(feedback: .selection)
                        }
                    }
                    .disabled(selected.date.isDateToday)
                    .accessibilityIdentifier("TodayButton")
                }
            }
            .sheet(isPresented: $showAverageSheet) {
                AverageView(
                    selected: selected,
                    showAverageSheet: $showAverageSheet
                )
            }
            .sheet(isPresented: $showCountersSheet) {
                CountersView(
                    selected: selected,
                    showCountersSheet: $showCountersSheet
                ) {
                    dismiss()
                }
            }
            .onChange(of: selected.date) { _, newValue in
                Task {
                    do {
                        selected.counter = try await Counter.fetch(date: newValue)
                        sensory.feedback(feedback: .selection)
                        dismiss()
                    } catch {
                        alert.error = .fetch
                        alert.show = true
                        sensory.feedback(feedback: .error)
                    }
                }
            }
        }
        .presentationDetents([.fraction(counters.isEmpty ? 0.5 : 0.4)])
    }
}

#Preview {
    Color
        .clear
        .sheet(isPresented: .constant(true)) {
            SettingsView(selected: Selected())
                .environment(Alert())
                .environment(Sensory())
                .modelContainer(
                    for: [Counter.self],
                    inMemory: true
                )
        }
}
