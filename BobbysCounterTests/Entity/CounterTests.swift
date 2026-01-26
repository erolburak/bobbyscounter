////
////  CounterTests.swift
////  BobbysCounterTests
////
////  Created by Burak Erol on 05.09.23.
////
//
//import Foundation
//import Testing
//
//@Suite("Counter tests")
//struct CounterTests {
//    // MARK: - Methods
//
//    @Test("Check Counter initializing!")
//    func counter() {
//        // Given
//        let counter: Counter?
//        // When
//        counter = Counter(
//            count: .zero,
//            date: .now,
//            decrementNegative: false,
//            step: .one
//        )
//        // Then
//        #expect(
//            counter != nil,
//            "Counter initializing failed!"
//        )
//    }
//
//    @Test("Check Counter decrement!")
//    func decrement() throws {
//        // Given
//        let counter = Counter(
//            count: 1,
//            date: .now,
//            decrementNegative: false,
//            step: .one
//        )
//        // When
//        try counter.decrement()
//        // Then
//        #expect(
//            counter.count == .zero,
//            "Counter decrement failed!"
//        )
//    }
//
//    @Test("Check Counter decrement with zero!")
//    func decrementWithZero() throws {
//        // Given
//        let counter = Counter(
//            count: .zero,
//            date: .now,
//            decrementNegative: false,
//            step: .one
//        )
//        // When
//        try counter.decrement()
//        // Then
//        #expect(
//            counter.count == .zero,
//            "Counter decrement with zero failed!"
//        )
//    }
//
//    @Test("Check Counter decrement with zero and decrementNegative with true!")
//    func decrementWithZeroAndDecrementNegativeWithTrue() throws {
//        // Given
//        let counter = Counter(
//            count: .zero,
//            date: .now,
//            decrementNegative: true,
//            step: .one
//        )
//        // When
//        try counter.decrement()
//        // Then
//        #expect(
//            counter.count == -1,
//            "Counter decrement with zero and decrementNegative with true failed!"
//        )
//    }
//
//    @Test("Check Counter increment!")
//    func increment() throws {
//        // Given
//        let counter = Counter(
//            count: .zero,
//            date: .now,
//            decrementNegative: false,
//            step: .one
//        )
//        // When
//        try counter.increment()
//        // Then
//        #expect(
//            counter.count == 1,
//            "Counter increment failed!"
//        )
//    }
//
//    @Test("Check Counter decrementNegative!")
//    func decrementNegative() throws {
//        // Given
//        let counter = Counter(
//            count: .zero,
//            date: .now,
//            decrementNegative: false,
//            step: .one
//        )
//        // When
//        try counter.decrementNegative(true)
//        // Then
//        #expect(
//            counter.decrementNegative == true,
//            "Counter decrementNegative failed!"
//        )
//    }
//
//    @Test("Check Counter resetCount!")
//    func resetCount() throws {
//        // Given
//        let counter = Counter(
//            count: 1,
//            date: .now,
//            decrementNegative: false,
//            step: .one
//        )
//        // When
//        try counter.resetCount()
//        // Then
//        #expect(
//            counter.count == .zero,
//            "Counter resetCount failed!"
//        )
//    }
//
//    @Test("Check Counter step!")
//    func step() throws {
//        // Given
//        let counter = Counter(
//            count: .zero,
//            date: .now,
//            decrementNegative: false,
//            step: .one
//        )
//        // When
//        try counter.step(.ten)
//        // Then
//        #expect(
//            counter.step == .ten,
//            "Counter step failed!"
//        )
//    }
//
//    @Test("Check Counter fetch!")
//    func fetch() async throws {
//        // Given
//        let date =
//            Calendar.current.date(
//                byAdding: DateComponents(day: +1),
//                to: .now
//            ) ?? .now
//        // When
//        let counter = try await Counter.fetch(date: date)
//        // Then
//        #expect(
//            counter == nil,
//            "Counter fetch failed!"
//        )
//    }
//
//    @Test("Check Counter insert!")
//    func insert() async throws {
//        // Given
//        let date =
//            Calendar.current.date(
//                byAdding: DateComponents(day: -2),
//                to: .now
//            ) ?? .now
//        // When
//        let id = try await Counter.insert(
//            date: date,
//            decrementNegative: false,
//            step: .one
//        )
//        // Then
//        #expect(
//            id != nil,
//            "Counter insert failed!"
//        )
//    }
//}
