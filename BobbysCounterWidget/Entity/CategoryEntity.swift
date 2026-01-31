//
//  CategoryEntity.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 27.01.26.
//

import AppIntents

struct CategoryEntity: AppEntity {
    // MARK: - Properties

    static let defaultQuery = CategoryEntityQuery()
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Category"
    let count: Int?
    let decrementNegative: Bool?
    let id: String
    let step: Steps?
    let title: String
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)")
    }
}

extension CategoryEntity {
    // MARK: - Properties

    static var preview: CategoryEntity? {
        CategoryEntity(
            count: .zero,
            decrementNegative: false,
            id: "Preview",
            step: .one,
            title: "Preview"
        )
    }
}
