//
//  CategoryEntityQuery.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 27.01.26.
//

import AppIntents
import SwiftData

struct CategoryEntityQuery: EntityQuery {
    // MARK: - Methods

    func entities(for identifiers: [String]) async throws -> [CategoryEntity] {
        try fetchCategories()
    }

    func suggestedEntities() async throws -> [CategoryEntity] {
        try fetchCategories()
    }

    private func fetchCategories() throws -> [CategoryEntity] {
        let context = ModelContext(CategoryActor.shared.modelContainer)
        return try context.fetch(
            FetchDescriptor<Category>()
        )
        .map {
            let counter = $0.counters?.first {
                $0.date?.toDateWithoutTime == .now.toDateWithoutTime
            }
            return CategoryEntity(
                count: counter?.count,
                decrementNegative: $0.decrementNegative,
                id: $0.title ?? "",
                step: $0.step,
                title: $0.title ?? ""
            )
        }
    }
}
