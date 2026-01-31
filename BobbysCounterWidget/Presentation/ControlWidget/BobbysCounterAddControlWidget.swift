//
//  BobbysCounterAddControlWidget.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 16.04.25.
//

import SwiftUI
import WidgetKit

struct BobbysCounterAddControlWidget: ControlWidget {
    // MARK: - Private Properties

    private let kind = "BobbysCounterAddControlWidget"

    // MARK: - Layouts

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: kind) {
            ControlWidgetButton(action: AddIntent()) {
                Label(
                    "AddTitle",
                    systemImage: "plus"
                )
            }
        }
        .displayName("AddTitle")
        .description("AddDescription")
    }
}
