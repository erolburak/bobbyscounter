//
//  SettingsTip.swift
//  BobbysCounter
//
//  Created by Burak Erol on 16.05.24.
//

import TipKit

struct SettingsTip: Tip {
    // MARK: - Properties

    @Parameter
    static var show: Bool = false
    var image: Image? = Image(systemName: "gearshape.circle.fill")
    var message: Text? = Text("SettingsTipMessage")
    var rules: [Rule] {
        [#Rule(Self.$show) {
            $0
        }]
    }

    var title = Text("Settings")
}
