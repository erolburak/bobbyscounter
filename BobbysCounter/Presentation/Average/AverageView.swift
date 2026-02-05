//
//  AverageView.swift
//  BobbysCounter
//
//  Created by Burak Erol on 15.01.24.
//

import SwiftUI

struct AverageView: View {
    // MARK: - Private Properties

    @Environment(Sensory.self) private var sensory
    @State private var averageMessage: String?
    private let averages = [7, 30, 90]
    private var average: String {
        /// Calculate average for last X items of counters depending on selected average value
        let counters = selected.category?.counters
        var value = 0.0
        for counter in counters?.prefix(selected.average) ?? [] {
            value += Double(counter.count)
        }
        return (value / Double(counters?.count ?? 0)).toString
    }
    private var presentationDetent: PresentationDetent {
        guard let counters = selected.category?.counters,
            !counters.isEmpty
        else {
            return .medium
        }
        return .fraction(0.25)
    }

    // MARK: - Properties

    @Bindable var selected: Selected
    @Binding var showAverageSheet: Bool

    // MARK: - Layouts

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                if selected.category?.counters?.isEmpty == false,
                    let averageMessage
                {
                    Picker(selection: $selected.average) {
                        ForEach(averages, id: \.self) {
                            Text($0.description)
                                .tag($0)
                        }
                    } label: {
                        Text("SelectedAverage")
                    }
                    .pickerStyle(.segmented)

                    Text(averageMessage)
                        .font(
                            .system(
                                .subheadline,
                                weight: .semibold
                            )
                        )
                        .padding(.vertical)
                        .contentTransition(.numericText())
                        .accessibilityIdentifier(Accessibility.averageMessage.id)
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
                    }
                    .accessibilityIdentifier(Accessibility.closeAverageButton.id)
                }
            }
            .onChange(of: selected.average) {
                sensory.feedback(.selection)
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
            }
        }
        .presentationDetents([presentationDetent])
    }
}

#Preview {
    AverageView(
        selected: Selected(),
        showAverageSheet: .constant(true)
    )
    .environment(Sensory())
}
