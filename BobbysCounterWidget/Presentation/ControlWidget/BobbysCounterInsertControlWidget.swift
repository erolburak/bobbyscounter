//
//  BobbysCounterInsertControlWidget.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 16.04.25.
//

import SwiftUI
import WidgetKit

struct BobbysCounterInsertControlWidget: ControlWidget {
    // MARK: - Private Properties

    private let kind = "BobbysCounterInsertControlWidget"

    // MARK: - Layouts

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: kind) {
            ControlWidgetButton(action: InsertIntent()) {
                Label(
                    "InsertTitle",
                    systemImage: "plus.circle.fill",
                )
            }
        }
        .displayName("InsertTitle")
        .description("InsertDescription")
    }
}
