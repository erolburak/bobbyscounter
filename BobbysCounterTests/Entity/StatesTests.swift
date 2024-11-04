//
//  StatesTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 04.11.24.
//

import Testing

struct StatesTests {
    // MARK: - Methods

    @Test("Check States initializing!")
    func testStates() {
        // Given
        let states: States?
        // When
        states = .isLoading
        // Then
        #expect(states != nil,
                "States initializing failed!")
    }
}
