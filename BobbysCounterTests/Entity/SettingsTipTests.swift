//
//  SettingsTipTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 16.05.24.
//

@testable import BobbysCounter
import XCTest

class SettingsTipTests: XCTestCase {

	// MARK: - Actions

	func testSettingsTip() {
		// Given
		let settingsTip: SettingsTip?
		// When
		settingsTip = SettingsTip()
		// Then
		XCTAssertNotNil(settingsTip)
	}
}
