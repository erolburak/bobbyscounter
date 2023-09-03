//
//  BobbysCounterApp.swift
//  BobbysCounter
//
//  Created by Burak Erol on 27.06.23.
//

import SwiftUI

@main
struct BobbysCounterApp: App {

	// MARK: - Layouts

	var body: some Scene {
		WindowGroup {
			ContentView(viewModel: ViewModelDI.shared.contentViewModel())
		}
	}
}
