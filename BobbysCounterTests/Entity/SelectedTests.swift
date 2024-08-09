//
//  SelectedTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 05.09.23.
//

@testable import BobbysCounter
import Testing

struct SelectedTests {

	// MARK: - Actions

	@Test("Check initializing Selected!")
	func testSelected() {
		// Given
		let selected: Selected?
		// When
		selected = Selected()
		// Then
		#expect(selected != nil,
				"Initializing Selected failed!")
	}
}
