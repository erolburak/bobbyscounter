//
//  ErrorsTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 28.01.24.
//

@testable import BobbysCounter
import Testing

struct ErrorsTests {

	// MARK: - Actions

	@Test("Check initializing Errors!")
	func testErrors() {
		for error in Errors.errors {
			// Given
			var newError: Error?
			// When
			newError = error
			// Then
			#expect(newError != nil,
					"Initializing Errors failed!")
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
