//
//  CategoryActorTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 08.08.24.
//

import Testing

@Suite("CategoryActor tests")
struct CategoryActorTests {
    // MARK: - Methods

    @Test("Check CategoryActor addCategory!")
    func addCategory() async throws {
        // Given
        let decrementNegative = false
        let step: Steps = .one
        let title = "Test"
        // Then
        await #expect(
            throws: Never.self,
            "CategoryActor addCategory failed!"
        ) {
            try await CategoryActor.shared.addCategory(
                decrementNegative: decrementNegative,
                step: step,
                title: title
            )
        }
    }

    @Test("Check CategoryActor addCounter!")
    func addCounter() async throws {
        // Given
        let category = Category.mock
        // Then
        await #expect(
            throws: Never.self,
            "CategoryActor addCounter failed!"
        ) {
            try await CategoryActor.shared.addCounter(
                categoryID: category.id,
                date: .now
            )
        }
    }

    @Test("Check CategoryActor delete!")
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
            "CategoryActor delete failed!"
        ) {
            try await CategoryActor.shared.delete(ids: [id])
        }
    }

    @Test("Check CategoryActor fetchCategoryID!")
    func fetchCategoryID() async throws {
        // Given
        let title = "FetchCategoryID"
        try await CategoryActor.shared.addCategory(
            decrementNegative: false,
            step: .one,
            title: title
        )
        // When
        let id = try await CategoryActor.shared.fetchCategoryID(title: title)
        // Then
        #expect(
            id != nil,
            "CategoryActor fetchID failed!"
        )
    }

    @Test("Check CategoryActor fetchCounterID!")
    func fetchCounterID() async throws {
        // Given
        let categoryID = try await CategoryActor.shared.addCategory(
            decrementNegative: false,
            step: .one,
            title: "FetchCounterID"
        )
        try await CategoryActor.shared.addCounter(
            categoryID: categoryID,
            date: .now
        )
        // When
        let id = try await CategoryActor.shared.fetchCounterID(
            categoryID: categoryID,
            date: .now
        )
        // Then
        #expect(
            id != nil,
            "CategoryActor fetchCounterID failed!"
        )
    }
}
