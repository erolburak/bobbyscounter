//
//  StatesTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 04.11.24.
//

import Testing

@Suite("States tests")
struct StatesTests {
    // MARK: - Methods

    @Test("Check States initializing!")
    func states() {
        // Given
        let states: States?
        // When
        states = .isLoading
        // Then
        #expect(
            states != nil,
            "States initializing failed!"
        )
    }
}
