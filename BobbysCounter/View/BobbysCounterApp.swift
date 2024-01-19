//
//  BobbysCounterApp.swift
//  BobbysCounter
//
//  Created by Burak Erol on 27.06.23.
//

import SwiftUI

@main
struct BobbysCounterApp: App {

	// MARK: - Private Properties

	@State private var alert = Alert()

	// MARK: - Layouts

	var body: some Scene {
		WindowGroup {
			ContentView(alert: alert)
				.alert(isPresented: $alert.show,
					   error: alert.error) { _ in
				} message: { error in
					if let message = error.recoverySuggestion {
						Text(message)
					}
				}
		}
		.modelContainer(Counter.modelContainer)
	}
}
