//
//  Counter.swift
//  BobbysCounter
//
//  Created by Burak Erol on 27.06.23.
//

import Foundation
import SwiftData

@Model
final class Counter {
    // MARK: - Properties

    var category: Category?
    var count = 0
    var date: Date?

    // MARK: - Lifecycle

    init(
        count: Int,
        date: Date
    ) {
        self.count = count
        self.date = date.toDateWithoutTime
    }

    // MARK: - Methods

    func decrement(_ value: Steps) throws {
        count -= value.rawValue
        try modelContext?.save()
    }

    func increment(_ value: Steps) throws {
        count += value.rawValue
        try modelContext?.save()
    }

    func resetCount() throws {
        count = .zero
        try modelContext?.save()
    }
}
