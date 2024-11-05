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
    func testErrors() {
        for error in Errors.errors {
            // Given
            var newError: Error?
            // When
            newError = error
            // Then
            #expect(newError != nil,
                    "Error initializing failed!")
        }
    }
}

private extension Errors {
    // MARK: - Properties

    static let errors: [Errors] = [.error(""),
                                   .fetch,
                                   .decrease,
                                   .increase]
}
