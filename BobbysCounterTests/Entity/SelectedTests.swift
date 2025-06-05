//
//  SelectedTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 05.09.23.
//

import Testing

@Suite("Selected tests")
struct SelectedTests {
    // MARK: - Methods

    @Test("Check Selected initializing!")
    func selected() {
        // Given
        let selected: Selected?
        // When
        selected = Selected()
        // Then
        #expect(selected != nil,
                "Selected initializing failed!")
    }
}
