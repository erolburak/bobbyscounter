//
//  Accessibility.swift
//  BobbysNewsDomain
//
//  Created by Burak Erol on 29.01.26.
//

enum Accessibility: String, CaseIterable {
    // MARK: - Properties

    case addCounterButton
    case averageButton
    case averageMessage
    case categoriesButton
    case categoriesListItem
    case categoryAlertConfirmButton
    case chart
    case closeAverageButton
    case closeCategoriesButton
    case closeCountersButton
    case closeSettingsButton
    case countText
    case countersButton
    case countersListItem
    case datePicker
    case decrementNegativeToggle
    case deleteCategoriesButton
    case deleteCategoriesButtonConfirmationDialog
    case deleteCategoryButtonConfirmationDialog
    case deleteCategoryButtonSwipeAction
    case deleteCounterButtonConfirmationDialog
    case deleteCounterButtonSwipeAction
    case deleteCountersButton
    case deleteCountersButtonConfirmationDialog
    case editButton
    case resetButton
    case resetButtonConfirmationDialog
    case settingsButton
    case settingsMenu
    case showCategoryAddButton
    case stepsPicker
    case todayButton

    var id: String { rawValue }
}
