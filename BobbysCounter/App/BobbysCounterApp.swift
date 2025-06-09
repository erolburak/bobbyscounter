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
                } message: {
                    if let message = $0.recoverySuggestion {
                        Text(message)
                    }
                }
                .sensoryFeedback(trigger: sensory.feedbackBool) { _, _ in
                    sensory.feedback
                }
                .task {
                    guard let tipsConfigurationOptions: [Tips.ConfigurationOption] = try? [.displayFrequency(.immediate),
                                                                                           .datastoreLocation(.groupContainer(identifier: "com.burakerol.BobbysCounter"))]
                    else {
                        return
                    }
                    #if DEBUG
                        CommandLine.arguments.contains("-testing") ? Tips.hideAllTipsForTesting() : try? Tips.configure(tipsConfigurationOptions)
                    #else
                        try? Tips.configure(tipsConfiguration)
                    #endif
                }
                .modelContainer(CounterActor.shared.modelContainer)
        }
    }
}
