//
//  CategoryEntity.swift
//  BobbysCounterWidget
//
//  Created by Burak Erol on 27.01.26.
//

import AppIntents

struct CategoryEntity: AppEntity {
    // MARK: - Properties

    static let defaultQuery = CategoryQuery()
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Category"
    let id: String
    let title: String
    var displayRepresentation: DisplayRepresentation { DisplayRepresentation(title: "\(title)") }
}
