//
//  SettingsTipTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 16.05.24.
//

import Testing

struct SettingsTipTests {
    // MARK: - Methods

    @Test("Check SettingsTip initializing!")
    func testSettingsTip() {
        // Given
        let settingsTip: SettingsTip?
        // When
        settingsTip = SettingsTip()
        // Then
        #expect(settingsTip != nil,
                "SettingsTip initializing failed!")
    }
}
