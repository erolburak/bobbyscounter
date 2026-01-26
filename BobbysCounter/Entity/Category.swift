//
//  Category.swift
//  BobbysCounter
//
//  Created by Burak Erol on 25.01.26.
//

import Foundation
import SwiftData

@Model
final class Category {
    // MARK: - Properties

    @Relationship(
        deleteRule: .cascade,
        inverse: \Counter.category
    )
    var counters: [Counter]?
    var decrementNegative: Bool?
    var step: Steps?
    var title: String?
    @Transient
    var countersSorted: [Counter]? {
        counters?.lazy.sorted {
            $0.date ?? .now > $1.date ?? .now
        }
    }

    // MARK: - Lifecycle

    init(
        counters: [Counter],
        decrementNegative: Bool,
        step: Steps,
        title: String
    ) {
        self.counters = counters
        self.decrementNegative = decrementNegative
        self.step = step
        self.title = title
    }

    // MARK: - Methods

    func decrementNegative(_ value: Bool) throws {
        decrementNegative = value
        try modelContext?.save()
    }

    func edit(title: String) throws {
        guard
            try modelContext?.fetch(
                FetchDescriptor<Category>(
                    predicate: #Predicate {
                        $0.title == title
                    }
                )
            ).isEmpty == true
        else {
            throw Errors.categoryEdit
        }
        self.title = title
        try modelContext?.save()
    }

    func step(_ value: Steps) throws {
        step = value
        try modelContext?.save()
    }

    @discardableResult
    static func insertCategory(
        decrementNegative: Bool,
        step: Steps,
        title: String
    ) async throws -> Category.ID {
        try await CategoryActor.shared.insertCategory(
            decrementNegative: decrementNegative,
            step: step,
            title: title
        )
    }

    @discardableResult
    static func insertCounter(
        categoryID: Category.ID,
        date: Date
    ) async throws -> Counter? {
        let id = try await CategoryActor.shared.insertCounter(
            categoryID: categoryID,
            date: date
        )
        let modelContext = ModelContext(CategoryActor.shared.modelContainer)
        return modelContext.model(for: id) as? Counter
    }

    static func fetchCounter(
        categoryID: Category.ID,
        date: Date
    ) async throws -> Counter? {
        guard
            let id = try await CategoryActor.shared.fetchCounterID(
                categoryID: categoryID,
                date: date
            )
        else {
            return nil
        }
        let modelContext = ModelContext(CategoryActor.shared.modelContainer)
        return modelContext.model(for: id) as? Counter
    }
}
