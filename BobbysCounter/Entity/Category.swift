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
            throw Errors.editCategory
        }
        self.title = title
        try modelContext?.save()
    }

    func step(_ value: Steps) throws {
        step = value
        try modelContext?.save()
    }

    @discardableResult
    static func add(
        decrementNegative: Bool,
        step: Steps,
        title: String
    ) async throws -> Category.ID {
        try await CategoryActor.shared.addCategory(
            decrementNegative: decrementNegative,
            step: step,
            title: title
        )
    }

    static func delete(ids: [Category.ID]) async throws {
        try await CategoryActor.shared.delete(ids: ids)
    }

    static func fetchID(title: String) async throws -> PersistentIdentifier? {
        try await CategoryActor.shared.fetchCategoryID(title: title)
    }
}

extension Category {
    // MARK: - Properties

    static var preview: Category {
        Category(
            counters: [.preview],
            decrementNegative: false,
            step: .one,
            title: "Preview"
        )
    }
}
