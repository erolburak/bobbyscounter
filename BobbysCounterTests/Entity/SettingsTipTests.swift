//
//  SettingsTipTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 16.05.24.
//

@testable import BobbysCounter
import Testing

struct SettingsTipTests {

	// MARK: - Actions

	@Test("Check initializing SettingsTip!")
	func testSettingsTip() {
		// Given
		let settingsTip: SettingsTip?
		// When
		settingsTip = SettingsTip()
		// Then
		#expect(settingsTip != nil,
				"Initializing SettingsTip failed!")
	}
}
