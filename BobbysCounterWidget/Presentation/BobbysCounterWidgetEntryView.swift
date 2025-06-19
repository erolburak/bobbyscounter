//
//  BobbysCounterWidgetEntryView.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 18.07.23.
//

import SwiftData
import SwiftUI

struct BobbysCounterWidgetEntryView: View {
    // MARK: - Private Properties

    @Query(
        sort: \Counter.date,
        order: .reverse
    ) private var counters: [Counter]
    private var count: Int? {
        counters.lazy.first { $0.date == .now.toDateWithoutTime }?.count
    }

    private var redactedReason: RedactionReasons {
        state == nil ? .placeholder : []
    }

    private var state: States? {
        count == nil ? .empty : .loaded
    }

    // MARK: - Properties

    let entry: BobbysCounterWidgetProvider.Entry

    // MARK: - Layouts

    var body: some View {
        Group {
            switch state {
            case .empty:
                ContentUnavailableView {
                    Label(
                        "EmptyCounter",
                        systemImage: "plus"
                    )
                    .imageScale(.small)
                    .font(.caption)
                } description: {
                    Text("EmptyCounterMessage")
                        .font(.caption2)
                        .fixedSize(horizontal: false, vertical: true)
                } actions: {
                    Button(
                        "Insert",
                        intent: InsertIntent()
                    )
                    .font(.footnote)
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                }
                .symbolVariant(.fill)
            default:
                let count = count ?? .zero

                Text(count.description)
                    .frame(maxWidth: .infinity)
                    .monospaced()
                    .font(.system(size: 1000))
                    .fontWeight(.black)
                    .minimumScaleFactor(0.001)
                    .lineLimit(1)
                    .opacity(0.25)
                    .contentTransition(.numericText())
                    .overlay {
                        HStack {
                            Button(
                                "Minus",
                                systemImage: "minus",
                                intent: DecreaseIntent()
                            )
                            .disabled(count <= .zero)

                            Spacer()

                            Button(
                                "Plus",
                                systemImage: "plus",
                                intent: IncreaseIntent()
                            )
                        }
                        .font(.system(size: 60))
                        .fontWeight(.bold)
                        .labelStyle(.iconOnly)
                    }
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .ignoresSafeArea()
        .overlay(alignment: .topLeading) {
            Text(entry.date.toRelative)
                .font(.caption)
                .fontWeight(.semibold)
        }
        .buttonStyle(.plain)
        .disabled(redactedReason == .placeholder)
        .redacted(reason: redactedReason)
        .widgetAccentable()
    }
}
