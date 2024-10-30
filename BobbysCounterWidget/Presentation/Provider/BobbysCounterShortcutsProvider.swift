//
//  BobbysCounterShortcutsProvider.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 30.10.24.
//

import AppIntents

struct BobbysCounterShortcutsProvider: AppShortcutsProvider {
    // MARK: - Properties

    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: DecreaseIntent(),
                    phrases: ["\(.applicationName) decrease",
                              "\(.applicationName) verringern"],
                    shortTitle: "DecreaseTitle",
                    systemImageName: "minus")

        AppShortcut(intent: IncreaseIntent(),
                    phrases: ["\(.applicationName) increase",
                              "\(.applicationName) erhöhen"],
                    shortTitle: "IncreaseTitle",
                    systemImageName: "plus")
    }
}
