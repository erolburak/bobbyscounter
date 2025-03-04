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

    @Query(sort: \Counter.date,
           order: .reverse) private var counters: [Counter]
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
        ZStack {
            switch state {
            case .empty:
                ContentUnavailableView {
                    Label("EmptyCounter",
                          systemImage: "plus")
                        .font(.system(size: 8))
                        .imageScale(.small)
                } description: {
                    Text("EmptyCounterMessage")
                        .font(.system(size: 6))
                } actions: {
                    Button("Insert",
                           intent: InsertIntent())
                        .textCase(.uppercase)
                        .font(.system(.subheadline,
                                      weight: .black))
                        .foregroundStyle(.red)
                }
                .frame(maxWidth: .infinity)
            default:
                let count = count ?? .zero

                Text(count.description)
                    .font(.system(size: 100))
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                    .opacity(0.25)
                    .padding()
                    .contentTransition(.numericText())

                HStack {
                    Button("Minus",
                           intent: DecreaseIntent())
                        .frame(maxWidth: .infinity)
                        .disabled(count <= .zero)

                    Button("Plus",
                           intent: IncreaseIntent())
                        .frame(maxWidth: .infinity)
                }
                .font(.system(size: 70))
            }
        }
        .environment(\.symbolVariants,
                     .circle.fill)
        .frame(maxHeight: .infinity)
        .ignoresSafeArea(.all)
        .overlay(alignment: .topTrailing) {
            Text(entry.date.toRelative)
                .font(.system(size: 8))
        }
        .disabled(redactedReason == .placeholder)
        .buttonStyle(.plain)
        .fontWeight(.bold)
        .monospaced()
        .redacted(reason: redactedReason)
        .widgetAccentable()
    }
}
