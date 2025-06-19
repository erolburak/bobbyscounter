//
//  CounterActorTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 08.08.24.
//

import Foundation
import SwiftData
import Testing

@Suite("CounterActor tests")
struct CounterActorTests {
    // MARK: - Methods

    @Test("Check CounterActor delete!")
    @MainActor
    func delete() async throws {
        // Given
        let date =
            Calendar.current.date(
                byAdding: DateComponents(day: -2),
                to: .now
            ) ?? .now
        let id = try await Counter.insert(date: date)?.persistentModelID
        // When
        try await CounterActor.shared.delete(ids: [id])
        // Then
        let modelContext = ModelContext(CounterActor.shared.modelContainer)
        let counter = try modelContext.fetch(
            FetchDescriptor<Counter>(predicate: #Predicate { $0.persistentModelID == id! })
        ).lazy.first
        #expect(
            counter == nil,
            "CounterActor delete failed!"
        )
    }

    @Test("Check CounterActor fetchID!")
    func fetchID() async throws {
        // Given
        let date =
            Calendar.current.date(
                byAdding: DateComponents(day: +1),
                to: .now
            ) ?? .now
        // When
        let id = try await CounterActor.shared.fetchID(date: date)
        // Then
        #expect(
            id == nil,
            "CounterActor fetchID failed!"
        )
    }

    @Test("Check CounterActor insert!")
    func insert() async throws {
        // Given
        let date =
            Calendar.current.date(
                byAdding: DateComponents(day: -2),
                to: .now
            ) ?? .now
        // Then
        await #expect(
            throws: Never.self,
            "CounterActor insert failed!"
        ) {
            try await CounterActor.shared.insert(date: date)
        }
    }
}
