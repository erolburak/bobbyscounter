//
//  DoubleExtensionTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 16.01.24.
//

import Testing

struct DoubleExtensionTests {
    // MARK: - Methods

    @Test("Check DoubleExtension toString!")
    func testToString() {
        // Given
        let double = 0.0
        // When
        let string = double.toString
        // Then
        #expect(string == "0",
                "DoubleExtension toString failed!")
    }

    @Test("Check DoubleExtension toString with three digits!")
    func testToStringWithThreeDigits() {
        // Given
        let double = 0.006
        // When
        let string = double.toString
        // Then
        #expect(string == "0.01",
                "DoubleExtension toString with three digits failed!")
    }
}
