//
//  CategoryActor.swift
//  BobbysCounter
//
//  Created by Burak Erol on 28.02.24.
//

import Foundation
import SwiftData

@ModelActor
actor CategoryActor {
    // MARK: - Properties

    static let shared = {
        do {
            var isStoredInMemoryOnly = false
            var cloudKitDatabase: ModelConfiguration.CloudKitDatabase = .automatic
            #if DEBUG
                if CommandLine.arguments.contains("-Testing") {
                    isStoredInMemoryOnly = true
                    cloudKitDatabase = .none
                }
            #endif
            let modelConfiguration = ModelConfiguration(
                isStoredInMemoryOnly: isStoredInMemoryOnly,
                cloudKitDatabase: cloudKitDatabase
            )
            let modelContainer = try ModelContainer(
                for: Schema([
                    Category.self,
                    Counter.self,
                ]),
                configurations: modelConfiguration
            )
            return CategoryActor(modelContainer: modelContainer)
        } catch {
            fatalError("Could not create model container: \(error)")
        }
    }()

    // MARK: - Methods

    func delete(ids: [PersistentIdentifier?]) throws {
        for id in ids {
            guard let id else {
                return
            }
            modelContext.delete(modelContext.model(for: id))
        }
        try modelContext.save()
    }

    func fetchCounterID(
        categoryID: Category.ID,
        date: Date
    ) throws -> Counter.ID? {
        let categories = try modelContext.fetch(
            FetchDescriptor<Category>(
                predicate: #Predicate {
                    $0.persistentModelID == categoryID
                }
            )
        )
        return categories.first?.counters?.lazy.first { $0.date == date.toDateWithoutTime }?
            .persistentModelID
    }

    func insertCategory(
        decrementNegative: Bool,
        step: Steps,
        title: String
    ) throws -> Category.ID {
        guard
            try modelContext.fetch(
                FetchDescriptor<Category>(
                    predicate: #Predicate {
                        $0.title == title
                    }
                )
            ).isEmpty
        else {
            throw Errors.categoryDuplicate
        }
        /// Insert new category if no category with given title exists
        let newCategory = Category(
            counters: [],
            decrementNegative: decrementNegative,
            step: step,
            title: title
        )
        modelContext.insert(newCategory)
        try modelContext.save()
        return newCategory.persistentModelID
    }

    func insertCounter(
        categoryID: Category.ID,
        date: Date
    ) throws -> Counter.ID {
        let category = try modelContext.fetch(
            FetchDescriptor<Category>(
                predicate: #Predicate {
                    $0.persistentModelID == categoryID
                }
            )
        ).first
        /// Insert new counter if no counter with given date exists
        guard
            let counter = category?.counters?.lazy.first(where: {
                $0.date == date.toDateWithoutTime
            })
        else {
            let newCounter = Counter(
                count: .zero,
                date: date
            )
            category?.counters?.append(newCounter)
            try modelContext.save()
            return newCounter.persistentModelID
        }
        /// Delete duplicate counters while initializing new array without first item in counters array
        if let duplicateCounters = category?.counters?.lazy.dropFirst() {
            try delete(ids: Array(duplicateCounters.lazy.map(\.persistentModelID)))
        }
        return counter.persistentModelID
    }
}
