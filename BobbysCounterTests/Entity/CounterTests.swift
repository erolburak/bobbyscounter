//
//  CounterTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 05.09.23.
//

import Foundation
import Testing

@Suite("Counter tests")
struct CounterTests {
    // MARK: - Methods

    @Test("Check Counter initializing!")
    func testCounter() {
        // Given
        let counter: Counter?
        // When
        counter = Counter(count: .zero,
                          date: .now)
        // Then
        #expect(counter != nil,
                "Counter initializing failed!")
    }

    @Test("Check Counter decrease!")
    func testDecrease() throws {
        // Given
        let counter = Counter(count: 1,
                              date: .now)
        // When
        try counter.decrease()
        // Then
        #expect(counter.count == .zero,
                "Counter decrease failed!")
    }

    @Test("Check Counter decrease with zero!")
    func testDecreaseWithZero() throws {
        // Given
        let counter = Counter(count: .zero,
                              date: .now)
        // When
        try counter.decrease()
        // Then
        #expect(counter.count == .zero,
                "Counter decrease with zero failed!")
    }

    @Test("Check Counter increase!")
    func testIncrease() throws {
        // Given
        let counter = Counter(count: .zero,
                              date: .now)
        // When
        try counter.increase()
        // Then
        #expect(counter.count == 1,
                "Counter increase failed!")
    }

    @Test("Check Counter fetch!")
    @MainActor
    func testFetch() async throws {
        // Given
        let date = Calendar.current.date(byAdding: DateComponents(day: +1),
                                         to: .now) ?? .now
        // When
        let counter = try await Counter.fetch(date: date)
        // Then
        #expect(counter == nil,
                "Counter fetch failed!")
    }

    @Test("Check Counter insert!")
    @MainActor
    func testInsert() async throws {
        // Given
        let date = Calendar.current.date(byAdding: DateComponents(day: -2),
                                         to: .now) ?? .now
        // When
        let id = try await Counter.insert(date: date)
        // Then
        #expect(id != nil,
                "Counter insert failed!")
    }
}
