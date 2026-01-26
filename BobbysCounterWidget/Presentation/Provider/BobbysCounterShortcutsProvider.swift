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

        AppShortcut(
            intent: InsertIntent(),
            phrases: [
                "\(.applicationName) insert",
                "\(.applicationName) hinzufügen",
            ],
            shortTitle: "InsertTitle",
            systemImageName: "plus"
        )
    }
}
