//
//  AlertTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 13.12.23.
//

import Testing

@Suite("Alert Tests")
struct AlertTests {
    // MARK: - Methods

    @Test("Check Alert initializing!")
    func alert() {
        // Given
        let alert: Alert?
        // When
        alert = Alert()
        // Then
        #expect(alert != nil,
                "Alert initializing  failed!")
    }
}
