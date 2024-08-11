//
//  SelectedTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 05.09.23.
//

import Testing

struct SelectedTests {

	// MARK: - Actions

	@Test("Check Selected initializing!")
	func testSelected() {
		// Given
		let selected: Selected?
		// When
		selected = Selected()
		// Then
		#expect(selected != nil,
				"Selected initializing failed!")
	}
}
