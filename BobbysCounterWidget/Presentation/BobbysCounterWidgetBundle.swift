//
//  BobbysCounterWidgetBundle.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 06.07.23.
//

import SwiftUI

@main
struct BobbysCounterWidgetBundle: WidgetBundle {
    // MARK: - Layouts

    var body: some Widget {
        BobbysCounterAddControlWidget()
        BobbysCounterDecrementControlWidget()
        BobbysCounterIncrementControlWidget()
        BobbysCounterWidget()
    }
}
