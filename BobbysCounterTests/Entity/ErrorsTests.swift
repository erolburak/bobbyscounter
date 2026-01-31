//
//  ErrorsTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 28.01.24.
//

import Testing

@Suite("Errors tests")
struct ErrorsTests {
    // MARK: - Methods

    @Test("Check Errors initializing!")
    func errors() {
        for error in Errors.errors {
            // Given
            var newError: Error?
            // When
            newError = error
            // Then
            #expect(
                newError != nil,
                "Error initializing failed!"
            )
        }
    }
}

extension Errors {
    // MARK: - Properties

    fileprivate static let errors: [Errors] = [
        .error("Test"),
        .addCategory,
        .addCounter,
        .editCategory,
        .fetch,
        .fetchWidget,
        .decrement,
        .increment,
        .decrementNegative,
        .resetCount,
        .step,
    ]
}
