//
//  SettingsTipTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 16.05.24.
//

import Testing

@Suite("SettingsTip tests")
struct SettingsTipTests {
    // MARK: - Methods

    @Test("Check SettingsTip initializing!")
    func settingsTip() {
        // Given
        let settingsTip: SettingsTip?
        // When
        settingsTip = SettingsTip()
        // Then
        #expect(
            settingsTip != nil,
            "SettingsTip initializing failed!"
        )
    }
}
