//
//  CategoryTests.swift
//  BobbysCategory
//
//  Created by Burak Erol on 29.01.26.
//

import SwiftData
import Testing

@Suite("Category tests")
struct CategoryTests {
    // MARK: - Methods

    @Test("Check Category add!")
    func add() async throws {
        // Given
        let id: Category.ID?
        // When
        id = try await Category.add(
            decrementNegative: false,
            step: .one,
            title: "Add"
        )
        // Then
        #expect(
            id != nil,
            "Category add failed!"
        )
    }

    @Test("Check Category initializing!")
    func category() {
        // Given
        let category: Category?
        // When
        category = Category(
            counters: [
                Counter(
                    count: .zero,
                    date: .now
                )
            ],
            decrementNegative: false,
            step: .one,
            title: "Category"
        )
        // Then
        #expect(
            category != nil,
            "Category initializing failed!"
        )
    }

    @Test("Check Category decrementNegative!")
    func decrementNegative() throws {
        // Given
        let category = Category.mock
        // When
        try category.decrementNegative(true)
        // Then
        #expect(
            category.decrementNegative == true,
            "Category decrementNegative failed!"
        )
    }

    @Test("Check Category delete!")
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
            "Category delete failed!"
        ) {
            try await Category.delete(ids: [id])
        }
    }

    @Test("Check Category edit!")
    func edit() throws {
        // Given
        let category = Category.mock
        // When
        try category.edit(title: "Edit")
        // Then
        #expect(
            category.title == "Edit",
            "Category edit failed!"
        )
    }

    @Test("Check Category fetchID!")
    func fetchID() async throws {
        // Given
        let category = Category.mock
        // When
        let id = try await Category.fetchID(title: category.title!)
        // Then
        #expect(
            id != nil,
            "Category fetchID failed!"
        )
    }

    @Test("Check Category step!")
    func step() throws {
        // Given
        let category = Category.mock
        // When
        try category.step(.ten)
        // Then
        #expect(
            category.step == .ten,
            "Category step failed!"
        )
    }
}

extension Category {
    // MARK: - Methods

    static var mock: Category {
        let modelContext = ModelContext(CategoryActor.shared.modelContainer)
        let category = Category(
            counters: [
                Counter(
                    count: .zero,
                    date: .now
                )
            ],
            decrementNegative: false,
            step: .one,
            title: "Mock"
        )
        modelContext.insert(category)
        return category
    }
}
