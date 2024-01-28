//
//  ErrorsTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 28.01.24.
//

@testable import BobbysCounter
import XCTest

class ErrorsTests: XCTestCase {

	// MARK: - Actions

	func testErrors() {
		for error in Errors.errors {
			// Given
			var newError: Error?
			// When
			newError = error
			// Then
			XCTAssertNotNil(newError)
		}
	}
}

private extension Errors {

	// MARK: - Properties

	static let errors: [Errors] = [.error(""),
								   .fetch]
}
