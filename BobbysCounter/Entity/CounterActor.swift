//
//  CounterActor.swift
//  BobbysCounter
//
//  Created by Burak Erol on 28.02.24.
//

import Foundation
import SwiftData

@ModelActor
actor CounterActor {
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
                for: Schema([Counter.self]),
                configurations: modelConfiguration
            )
            return CounterActor(modelContainer: modelContainer)
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

    func fetchID(date: Date) throws -> Counter.ID? {
        try modelContext.fetch(
            FetchDescriptor<Counter>(predicate: #Predicate { $0.date == date.toDateWithoutTime })
        ).lazy.first?.persistentModelID
    }

    func insert(date: Date) throws -> Counter.ID {
        let counters = try modelContext.fetch(
            FetchDescriptor<Counter>(predicate: #Predicate { $0.date == date.toDateWithoutTime }))
        /// Insert new counter if no counter with given date exists
        guard let counter = counters.lazy.first else {
            let newCounter = Counter(
                count: .zero,
                date: date
            )
            modelContext.insert(newCounter)
            try modelContext.save()
            return newCounter.persistentModelID
        }
        /// Delete duplicate counters while initializing new array without first item in counters array
        let duplicateCounters = counters.lazy.dropFirst()
        try delete(ids: Array(duplicateCounters.lazy.map(\.persistentModelID)))
        return counter.persistentModelID
    }
}
