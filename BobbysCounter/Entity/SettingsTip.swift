//
//  SettingsTip.swift
//  BobbysCounter
//
//  Created by Burak Erol on 16.05.24.
//

import TipKit

struct SettingsTip: Tip {

	// MARK: - Properties

	var image: Image? = Image(systemName: "gearshape.circle.fill")
	var message: Text? = Text("SettingsTipMessage")
	var title = Text("Settings")
}
