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

    func decrement() throws {
        guard let step = category?.step?.rawValue else {
            throw Errors.step
        }
        if category?.decrementNegative == false,
            count - step < .zero
        {
            throw Errors.decrement
        }
        count -= step
        try modelContext?.save()
    }

    func increment() throws {
        guard let step = category?.step?.rawValue else {
            throw Errors.step
        }
        count += step
        try modelContext?.save()
    }

    func resetCount() throws {
        count = .zero
        try modelContext?.save()
    }

    @discardableResult
    static func add(
        categoryID: PersistentIdentifier,
        date: Date
    ) async throws -> Counter? {
        let counterID = try await CategoryActor.shared.addCounter(
            categoryID: categoryID,
            date: date
        )
        let modelContext = ModelContext(CategoryActor.shared.modelContainer)
        return modelContext.model(for: counterID) as? Counter
    }

    static func delete(ids: [PersistentIdentifier]) async throws {
        try await CategoryActor.shared.delete(ids: ids)
    }

    static func fetch(
        categoryID: PersistentIdentifier,
        date: Date
    ) async throws -> Counter? {
        guard
            let counterID = try await CategoryActor.shared.fetchCounterID(
                categoryID: categoryID,
                date: date
            )
        else {
            return nil
        }
        let modelContext = ModelContext(CategoryActor.shared.modelContainer)
        return modelContext.model(for: counterID) as? Counter
    }
}

extension Counter {
    // MARK: - Properties

    static var preview: Counter {
        Counter(
            count: 1,
            date: .now
        )
    }
}
