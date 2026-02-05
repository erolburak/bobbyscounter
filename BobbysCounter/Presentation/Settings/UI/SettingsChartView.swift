//
//  ChartView.swift
//  BobbysCounter
//
//  Created by Burak Erol on 12.12.23.
//

import Charts
import SwiftData
import SwiftUI

struct ChartView: View {
    // MARK: - Private Properties

    @Environment(Sensory.self) private var sensory
    @State private var chartScrollPosition = Date.now
    @State private var selectedPointMarkDate: Date?
    private var chartXVisibleDomainLength: Int {
        /// Calculate factor by multiplying seconds, minutes and hours together
        let factor = 60 * 60 * 24
        let count = counters.count
        let range = 3...4
        return range.contains(count) ? count * factor : range.upperBound * factor
    }
    private var counters: [Counter] {
        selected.category?.countersSorted ?? []
    }
    private var selectedPointMarkCounter: Counter? {
        counters.lazy.first { $0.date == selectedPointMarkDate?.toDateWithoutTime }
    }

    // MARK: - Properties

    @Bindable var selected: Selected

    // MARK: - Layouts

    var body: some View {
        Chart(counters) {
            let date = $0.date ?? .now

            LineMark(
                x: .value(
                    "Date",
                    date,
                    unit: .day
                ),
                y: .value(
                    "Count",
                    $0.count
                )
            )
            .interpolationMethod(.monotone)
            .lineStyle(
                StrokeStyle(
                    lineWidth: 1,
                    dash: [2]))

            PointMark(
                x: .value(
                    "Date",
                    date,
                    unit: .day
                ),
                y: .value(
                    "Count",
                    $0.count
                )
            )
            .annotation(
                position: .topLeading,
                spacing: 24,
                overflowResolution: AnnotationOverflowResolution(
                    x: .fit(to: .chart),
                    y: .fit(to: .chart)
                )
            ) {
                if showAnnotation(date: date),
                    let selectedPointMarkCounter
                {
                    Text(selectedPointMarkCounter.count.description)
                        .font(
                            .system(
                                .title,
                                weight: .black
                            )
                        )
                        .monospacedDigit()
                }
            }
        }
        .chartScrollableAxes(.horizontal)
        .chartScrollPosition(x: $chartScrollPosition)
        .chartXVisibleDomain(length: chartXVisibleDomainLength)
        .chartXSelection(value: $selectedPointMarkDate)
        .chartXScale(range: .plotDimension(padding: 12))
        .chartYScale(range: .plotDimension(padding: 12))
        .frame(height: 120)
        .fixedSize(
            horizontal: false,
            vertical: true
        )
        .padding(.horizontal)
        .font(.system(size: 10))
        .onChange(of: selectedPointMarkDate) { oldValue, newValue in
            if selectedPointMarkCounter != nil,
                oldValue?.toDateWithoutTime != newValue?.toDateWithoutTime
            {
                sensory.feedback(.selection)
            }
        }
        .task {
            guard
                let dateMinusOne = Calendar.current.date(
                    byAdding: DateComponents(day: -1),
                    to: selected.date)
            else {
                return
            }
            chartScrollPosition = dateMinusOne
        }
        .accessibilityIdentifier(Accessibility.chart.id)
    }

    // MARK: - Methods

    private func showAnnotation(date: Date) -> Bool {
        date.formatted(
            date: .complete,
            time: .omitted
        )
            == selectedPointMarkDate?.formatted(
                date: .complete,
                time: .omitted
            )
    }
}

#Preview {
    ChartView(selected: Selected())
        .environment(Sensory())
}
