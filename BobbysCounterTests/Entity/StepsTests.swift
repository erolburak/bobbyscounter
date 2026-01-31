//
//  StepsTests.swift
//  BobbysCounter
//
//  Created by Burak Erol on 25.01.26.
//

import Testing

@Suite("Steps tests")
struct StepsTests {
    // MARK: - Methods

    @Test("Check Steps initializing!")
    func steps() {
        for step in Steps.allCases {
            // Given
            var newStep: Steps?
            // When
            newStep = step
            // Then
            #expect(
                newStep != nil,
                "Step initializing failed!"
            )
        }
    }
}
