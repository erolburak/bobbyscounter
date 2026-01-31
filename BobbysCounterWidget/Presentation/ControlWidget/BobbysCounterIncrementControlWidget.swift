//
//  BobbysCounterIncrementControlWidget.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 16.04.25.
//

import SwiftUI
import WidgetKit

struct BobbysCounterIncrementControlWidget: ControlWidget {
    // MARK: - Private Properties

    private let kind = "BobbysCounterIncrementControlWidget"

    // MARK: - Layouts

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: kind) {
            ControlWidgetButton(action: IncrementIntent()) {
                Label(
                    "IncrementTitle",
                    systemImage: "plus"
                )
            }
        }
        .displayName("IncrementTitle")
        .description("IncrementDescription")
    }
}
