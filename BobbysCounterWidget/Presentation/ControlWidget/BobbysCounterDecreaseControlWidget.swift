//
//  BobbysCounterDecreaseControlWidget.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 16.04.25.
//

import SwiftUI
import WidgetKit

struct BobbysCounterDecreaseControlWidget: ControlWidget {
    // MARK: - Private Properties

    private let kind = "BobbysCounterDecreaseControlWidget"

    // MARK: - Layouts

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: kind) {
            ControlWidgetButton("test", action: DecreaseIntent()) { _ in
                Label(
                    "DecreaseTitle",
                    systemImage: "minus"
                )
            }
        }
        .displayName("DecreaseTitle")
        .description("DecreaseDescription")
    }
}
