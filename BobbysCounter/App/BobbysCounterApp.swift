//
//  BobbysCounterApp.swift
//  BobbysCounter
//
//  Created by Burak Erol on 27.06.23.
//

import TipKit

@main
struct BobbysCounterApp: App {
    // MARK: - Private Properties

    @State private var alert = Alert()
    @State private var sensory = Sensory()

    // MARK: - Layouts

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(alert)
                .environment(sensory)
                .alert(isPresented: $alert.show,
                       error: alert.error)
            { _ in
            } message: { error in
                if let message = error.recoverySuggestion {
                    Text(message)
                }
            }
            .sensoryFeedback(trigger: sensory.feedbackBool) { _, _ in
                sensory.feedback
            }
            .task {
                try? Tips.configure([.displayFrequency(.immediate),
                                     .datastoreLocation(.groupContainer(identifier: "com.burakerol.BobbysCounter"))])
            }
            .modelContainer(CounterActor.shared.modelContainer)
        }
    }
}
