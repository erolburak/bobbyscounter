//
//  BobbysCounterShortcutsProvider.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 30.10.24.
//

import AppIntents

struct BobbysCounterShortcutsProvider: AppShortcutsProvider {
    // MARK: - Properties

    static let shortcutTileColor: ShortcutTileColor = .grayBlue

    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddIntent(),
            phrases: [
                "\(.applicationName) add",
                "\(.applicationName) hinzufügen",
            ],
            shortTitle: "AddTitle",
            systemImageName: "plus"
        )

        AppShortcut(
            intent: DecrementIntent(),
            phrases: [
                "\(.applicationName) decrement",
                "\(.applicationName) verringern",
            ],
            shortTitle: "DecrementTitle",
            systemImageName: "minus"
        )

        AppShortcut(
            intent: IncrementIntent(),
            phrases: [
                "\(.applicationName) increment",
                "\(.applicationName) erhöhen",
            ],
            shortTitle: "IncrementTitle",
            systemImageName: "plus"
        )
    }
}
