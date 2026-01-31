//
//  CounterTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 05.09.23.
//

import Testing

@Suite("Counter tests")
struct CounterTests {
    // MARK: - Methods

    @Test("Check Counter add!")
    func add() async throws {
        // Given
        let category = Category.mock
        // When
        let id = try await Counter.add(
            categoryID: category.persistentModelID,
            date: .now
        )
        // Then
        #expect(
            id != nil,
            "Counter add failed!"
        )
    }

    @Test("Check Counter initializing!")
    func counter() {
        // Given
        let counter: Counter?
        // When
        counter = Category.mock.counters?.first
        // Then
        #expect(
            counter != nil,
            "Counter initializing failed!"
        )
    }

    @Test("Check Counter decrement!")
    func decrement() throws {
        // Given
        let counter = Category.mock.counters?.first
        try counter?.increment()
        // When
        try counter?.decrement()
        // Then
        #expect(
            counter?.count == 0,
            "Counter decrement failed!"
        )
    }

    @Test("Check Counter delete!")
    func delete() async throws {
        // Given
        let id = try await CategoryActor.shared.addCategory(
            decrementNegative: false,
            step: .one,
            title: "Delete"
        )
        // Then
        await #expect(
            throws: Never.self,
            "Counter delete failed!"
        ) {
            try await Counter.delete(ids: [id])
        }
    }

    @Test("Check Counter fetch!")
    func fetch() async throws {
        // Given
        let category = Category.mock
        // When
        let id = try await Counter.fetch(
            categoryID: category.persistentModelID,
            date: .now
        )
        // Then
        #expect(
            id == nil,
            "Counter fetch failed!"
        )
    }

    @Test("Check Counter increment!")
    func increment() throws {
        // Given
        let counter = Category.mock.counters?.first
        // When
        try counter?.increment()
        // Then
        #expect(
            counter?.count == 1,
            "Counter increment failed!"
        )
    }

    @Test("Check Counter resetCount!")
    func resetCount() throws {
        // Given
        let counter = Category.mock.counters?.first
        // When
        try counter?.resetCount()
        // Then
        #expect(
            counter?.count == .zero,
            "Counter resetCount failed!"
        )
    }
}
