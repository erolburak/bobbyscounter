//
//  BobbysCounterDecrementControlWidget.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 16.04.25.
//

import SwiftUI
import WidgetKit

struct BobbysCounterDecrementControlWidget: ControlWidget {
    // MARK: - Private Properties

    private let kind = "BobbysCounterDecrementControlWidget"

    // MARK: - Layouts

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: kind) {
            ControlWidgetButton(action: DecrementIntent()) {
                Label(
                    "DecrementTitle",
                    systemImage: "minus"
                )
            }
        }
        .displayName("DecrementTitle")
        .description("DecrementDescription")
    }
}
