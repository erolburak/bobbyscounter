//
//  BobbysCounterApp.swift
//  BobbysCounter
//
//  Created by Burak Erol on 27.06.23.
//

import SwiftUI
import WidgetKit

@main
struct BobbysCounterApp: App {

	// MARK: - Private Properties

	@Environment(\.scenePhase) private var scenePhase
	@State private var alert = Alert()
	@State private var selected = Selected()
	@State private var sensoryFeedback: SensoryFeedback = .success
	@State private var sensoryFeedbackTrigger = false

	// MARK: - Layouts

	var body: some Scene {
		WindowGroup {
			ContentView(alert: alert,
						selected: selected)
			.alert(isPresented: $alert.show,
				   error: alert.error) { _ in
			} message: { error in
				if let message = error.recoverySuggestion {
					Text(message)
				}
			}
			.onChange(of: scenePhase) {
				switch scenePhase {
				case .active:
					do {
						selected.counter = try Counter.fetch(SharedModelContainer.shared.modelContainer.mainContext,
															 date: selected.date)
					} catch {
						alert.error = .fetch
						alert.show = true
						sensoryFeedback = .error
						sensoryFeedbackTrigger = true
					}
				case .background:
					WidgetCenter.shared.reloadAllTimelines()
				default: break
				}
			}
			.sensoryFeedback(sensoryFeedback,
							 trigger: sensoryFeedbackTrigger) { _, newValue in
				sensoryFeedbackTrigger = false
				return newValue == true
			}
		}
		.modelContainer(SharedModelContainer.shared.modelContainer)
	}
}
