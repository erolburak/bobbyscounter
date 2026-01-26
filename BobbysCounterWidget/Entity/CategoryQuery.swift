//
//  CategoryQuery.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 27.01.26.
//

import AppIntents
import SwiftData

struct CategoryQuery: EntityQuery {
    // MARK: - Methods

    func entities(for identifiers: [String]) async throws -> [CategoryEntity] {
        try fetchCategories()
    }

    func suggestedEntities() async throws -> [CategoryEntity] {
        try fetchCategories()
    }

    private func fetchCategories() throws -> [CategoryEntity] {
        let context = ModelContext(CategoryActor.shared.modelContainer)
        return try context.fetch(FetchDescriptor<Category>())
            .map { CategoryEntity(id: $0.title ?? "", title: $0.title ?? "") }
    }
}
