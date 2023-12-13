//
//  SelectedTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 05.09.23.
//

@testable import BobbysCounter
import XCTest

class SelectedTests: XCTestCase {

	// MARK: - Actions

	func testSelected() {
		// Given
		let selected: Selected?
		// When
		selected = Selected()
		// Then
		XCTAssertNotNil(selected)
	}
}
