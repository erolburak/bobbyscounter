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

    @discardableResult
    func addCategory(
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
            throw Errors.addCategory
        }
        /// Add new category if no category with given title exists
        let newCategory = Category(
            counters: [],
            decrementNegative: decrementNegative,
            step: step,
            title: title
        )
        modelContext.insert(newCategory)
        try modelContext.save()
        return newCategory.id
    }

    @discardableResult
    func addCounter(
        categoryID: Category.ID,
        date: Date
    ) throws -> Counter.ID {
        guard
            try modelContext.fetch(
                FetchDescriptor<Counter>(
                    predicate: #Predicate {
                        $0.category?.id == categoryID && $0.date == date.toDateWithoutTime
                    }
                )
            ).isEmpty
        else {
            throw Errors.addCounter
        }
        /// Add new counter if no counter with given date exists
        let newCounter = Counter(
            count: .zero,
            date: date
        )
        try modelContext.fetch(
            FetchDescriptor<Category>(
                predicate: #Predicate {
                    $0.id == categoryID
                }
            )
        ).first?.counters?.append(newCounter)
        try modelContext.save()
        return newCounter.id
    }

    func delete(ids: [PersistentIdentifier?]) throws {
        for id in ids {
            guard let id else {
                return
            }
            modelContext.delete(modelContext.model(for: id))
        }
        try modelContext.save()
    }

    func fetchCategoryID(title: String) throws -> Category.ID? {
        try modelContext.fetch(
            FetchDescriptor<Category>(
                predicate: #Predicate {
                    $0.title == title
                }
            )
        ).first?.id
    }

    func fetchCounterID(
        categoryID: Category.ID,
        date: Date
    ) throws -> Counter.ID? {
        try modelContext.fetch(
            FetchDescriptor<Category>(
                predicate: #Predicate {
                    $0.id == categoryID
                }
            )
        ).first?.counters?.lazy.first { $0.date == date.toDateWithoutTime }?.id
    }
}
