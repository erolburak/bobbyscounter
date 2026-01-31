//
//  CategoriesViewTests.swift
//  BobbysCounter
//
//  Created by Burak Erol on 29.01.26.
//

import XCTest

final class CategoriesViewTests: XCTestCase {
    // MARK: - Methods

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testCategoriesView() {
        /// Launch app
        let app = XCUIApplication().appLaunch()
        showCategoriesView(with: app)
        deleteCategories(with: app)
        app.addNewCategory(with: app)
        showCategoriesView(with: app)
        editCategory(with: app)
        deleteCategory(with: app)
        closeCategoriesView(with: app)
    }

    @MainActor
    private func closeCategoriesView(with app: XCUIApplication) {
        /// Close categories view
        app.buttons[Accessibility.closeCategoriesButton.id].waitForExistence().tap()
    }

    @MainActor
    private func deleteCategory(with app: XCUIApplication) {
        /// Swipe to delete category
        app.buttons[Accessibility.categoriesListItem.id].waitForExistence().swipeLeft()
        /// Delete category
        app.buttons[Accessibility.deleteCategoryButtonSwipeAction.id].waitForExistence().tap()
        /// Confirm delete
        app.buttons[Accessibility.deleteCategoryButtonConfirmationDialog.id].firstMatch
            .waitForExistence().tap()
    }

    @MainActor
    private func deleteCategories(with app: XCUIApplication) {
        /// Show delete categories
        app.buttons[Accessibility.deleteCategoriesButton.id].waitForExistence().tap()
        /// Confirm delete
        app.buttons[Accessibility.deleteCategoriesButtonConfirmationDialog.id].firstMatch
            .waitForExistence().tap()
        /// Check if `ShowCategoryAddButton` exists
        app.buttons[Accessibility.showCategoryAddButton.id].waitForExistence()
    }

    @MainActor
    private func editCategory(with app: XCUIApplication) {
        /// Swipe to edit category
        app.buttons[Accessibility.categoriesListItem.id].waitForExistence().swipeLeft()
        /// Edit category
        app.buttons[Accessibility.editButton.id].waitForExistence().tap()
        /// Set category to `TestEdit`
        let textField = app.textFields.firstMatch.waitForExistence()
        textField.doubleTap()
        textField.typeText("Edit")
        /// Confirm selected category
        app.buttons[Accessibility.categoryAlertConfirmButton.id].firstMatch.waitForExistence().tap()
    }

    @MainActor
    private func showCategoriesView(with app: XCUIApplication) {
        /// Show settings menu
        app.showSettingsMenu(with: app)
        /// Show categories view
        app.buttons[Accessibility.categoriesButton.id].waitForExistence().tap()
    }
}
