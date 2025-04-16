//
//  BobbysCounterIncreaseControlWidget.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 16.04.25.
//

import SwiftUI
import WidgetKit

struct BobbysCounterIncreaseControlWidget: ControlWidget {
    // MARK: - Private Properties

    private let kind = "BobbysCounterIncreaseControlWidget"

    // MARK: - Layouts

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: kind) {
            ControlWidgetButton(action: IncreaseIntent()) {
                Label(
                    "IncreaseTitle",
                    systemImage: "plus"
                )
            }
        }
        .displayName("IncreaseTitle")
        .description("IncreaseDescription")
    }
}
