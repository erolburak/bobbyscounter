//
//  AverageView.swift
//  BobbysCounter
//
//  Created by Burak Erol on 15.01.24.
//

import SwiftData
import SwiftUI

struct AverageView: View {
    // MARK: - Private Properties

    @Environment(Sensory.self) private var sensory
    @Query(
        sort: \Counter.date,
        order: .reverse
    ) private var counters: [Counter]
    @State private var averageMessage: String?
    private let averages = [7, 30, 90]
    private var average: String {
        /// Calculate average for last X items of counters depending on selected average value
        var value = 0.0
        for counter in counters.prefix(selected.average) {
            value += Double(counter.count)
        }
        return (value / Double(counters.count)).toString
    }

    // MARK: - Properties

    @Bindable var selected: Selected
    @Binding var showAverageSheet: Bool

    // MARK: - Layouts

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                if !counters.isEmpty,
                    let averageMessage
                {
                    Picker(selection: $selected.average) {
                        ForEach(averages, id: \.self) {
                            Text($0.description)
                        }
                    } label: {
                        Text("SelectedAverage")
                    }
                    .pickerStyle(.segmented)
                    .accessibilityIdentifier("AveragePicker")

                    Text(averageMessage)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.vertical)
                        .contentTransition(.numericText())
                        .accessibilityIdentifier("AverageMessage")
                } else {
                    ContentUnavailableView {
                        Label(
                            "EmptyAverage",
                            systemImage: "divide"
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
            .padding(.horizontal)
            .navigationTitle("Average")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close) {
                        showAverageSheet = false
                        sensory.feedback(feedback: .press(.button))
                    }
                    .accessibilityIdentifier("CloseAverageButton")
                }
            }
            .onChange(
                of: selected.average,
                initial: true
            ) {
                withAnimation {
                    averageMessage = String(
                        localized: "AverageMessage\(selected.average)\(average)"
                    )
                }
                sensory.feedback(feedback: .selection)
            }
        }
        .presentationDetents([.fraction(counters.isEmpty ? 0.5 : 0.25)])
    }
}

#Preview {
    AverageView(
        selected: Selected(),
        showAverageSheet: .constant(true)
    )
    .environment(Sensory())
    .modelContainer(
        for: [Counter.self],
        inMemory: true
    )
}
