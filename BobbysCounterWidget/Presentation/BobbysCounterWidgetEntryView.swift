//
//  BobbysCounterWidgetEntryView.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 18.07.23.
//

import SwiftUI

struct BobbysCounterWidgetEntryView: View {
    // MARK: - Private Properties

    private var count: Int {
        entry.categoryEntity?.count ?? 0
    }
    private var isDecrementDisabled: Bool {
        guard let decrementNegative = entry.categoryEntity?.decrementNegative,
            let step = entry.categoryEntity?.step?.rawValue
        else {
            return false
        }
        return !decrementNegative && count - step < .zero
    }
    private var redactedReason: RedactionReasons {
        state == nil ? .placeholder : []
    }
    private var state: States? {
        entry.categoryEntity?.title == nil
            ? .emptyCategory : entry.categoryEntity?.count == nil ? .emptyCounter : .loaded
    }
    private var title: String {
        entry.categoryEntity?.title ?? ""
    }

    // MARK: - Properties

    let entry: BobbysCounterWidgetProvider.Entry

    // MARK: - Layouts

    var body: some View {
        Group {
            switch state {
            case .emptyCategory:
                ContentUnavailableView {
                    Label(
                        "EmptyCategoryWidget",
                        systemImage: "plus"
                    )
                    .imageScale(.small)
                    .font(.system(.caption))
                } description: {
                    Text("EmptyCategoryMessageWidget")
                        .font(.system(.caption))
                        .fixedSize(
                            horizontal: false,
                            vertical: true
                        )
                }
                .symbolVariant(.fill)
            case .emptyCounter:
                ContentUnavailableView {
                    Label(
                        "EmptyCounter",
                        systemImage: "plus"
                    )
                    .imageScale(.small)
                    .font(.system(.caption))
                } description: {
                    Text("EmptyCounterMessage")
                        .font(.system(.caption2))
                        .fixedSize(
                            horizontal: false,
                            vertical: true
                        )
                } actions: {
                    Button(
                        "Add",
                        intent: AddIntent(title: title)
                    )
                    .font(
                        .system(
                            .footnote,
                            weight: .bold
                        )
                    )
                    .textCase(.uppercase)
                }
                .symbolVariant(.fill)
            default:
                Text(count.description)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
                    .font(
                        .system(
                            size: 100,
                            weight: .black
                        )
                    )
                    .monospacedDigit()
                    .minimumScaleFactor(0.001)
                    .lineLimit(1)
                    .opacity(0.25)
                    .contentTransition(.numericText())
                    .overlay(alignment: .topLeading) {
                        VStack(
                            alignment: .leading,
                            spacing: .none
                        ) {
                            Text(entry.date.toRelative)
                                .font(
                                    .system(
                                        size: 8,
                                        weight: .semibold
                                    )
                                )
                                .foregroundStyle(.secondary)

                            Text(entry.categoryEntity?.title ?? "")
                                .font(
                                    .system(
                                        size: 10,
                                        weight: .bold
                                    )
                                )
                                .lineLimit(1)
                        }
                    }
                    .overlay(alignment: .bottom) {
                        HStack {
                            Button(
                                "Minus",
                                systemImage: "minus",
                                intent: DecrementIntent(title: title)
                            )
                            .disabled(isDecrementDisabled)

                            Spacer()

                            Button(
                                "Plus",
                                systemImage: "plus",
                                intent: IncrementIntent(title: title)
                            )
                        }
                        .font(
                            .system(
                                size: 40,
                                weight: .heavy
                            )
                        )
                        .labelStyle(.iconOnly)
                    }
            }
        }
        .buttonStyle(.plain)
        .disabled(redactedReason == .placeholder)
        .redacted(reason: redactedReason)
        .widgetAccentable()
        .widgetURL(
            URL(string: "bobbyscounter://category?title=\(entry.categoryEntity?.title ?? "")")
        )
    }
}
