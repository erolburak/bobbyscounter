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
    @Query(sort: \Counter.date,
           order: .reverse) private var counters: [Counter]
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
                    HStack {
                        Text("SelectedAverage")

                        Spacer()

                        Picker(selection: $selected.average) {
                            ForEach(averages, id: \.self) { average in
                                Text(average.description)
                            }
                        } label: {
                            EmptyView()
                        }
                        .pickerStyle(.menu)
                        .accessibilityIdentifier("AveragePicker")
                    }
                    .padding()

                    Spacer()

                    Text(averageMessage)
                        .font(.caption)
                        .fontWeight(.regular)
                        .padding(.horizontal)
                        .contentTransition(.numericText())
                        .accessibilityIdentifier("AverageMessage")
                } else {
                    ContentUnavailableView("EmptyAverage",
                                           systemImage: "divide",
                                           description: Text("EmptyCountersMessage"))
                        .symbolEffect(.bounce,
                                      options: .nonRepeating)
                }

                Spacer()
            }
            .navigationTitle("Average")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close",
                           systemImage: "xmark")
                    {
                        showAverageSheet = false
                    }
                    .accessibilityIdentifier("CloseAverageButton")
                }
            }
            .onAppear {
                updateAverageMessage()
            }
            .onChange(of: selected.average) {
                updateAverageMessage()
                sensory.feedback(feedback: .selection)
            }
        }
        .presentationDetents([.fraction(counters.isEmpty ? 0.6 : 0.4)])
    }

    // MARK: - Methods

    private func updateAverageMessage() {
        withAnimation {
            averageMessage = String(localized: "AverageMessage\(selected.average)\(average)")
        }
    }
}

#Preview {
    AverageView(selected: Selected(),
                showAverageSheet: .constant(true))
        .environment(Sensory())
        .modelContainer(for: [Counter.self],
                        inMemory: true)
}
