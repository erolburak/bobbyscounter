//
//  AlertTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 13.12.23.
//

import Testing

struct AlertTests {
    // MARK: - Methods

    @Test("Check Alert initializing!")
    func testAlert() {
        // Given
        let alert: Alert?
        // When
        alert = Alert()
        // Then
        #expect(alert != nil,
                "Alert initializing  failed!")
    }
}
