//
//  ViewModelDITests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 04.09.23.
//

@testable import BobbysCounter
import XCTest

class ViewModelDITests: XCTestCase {

	private var sut: ViewModelDI!

	override func setUpWithError() throws {
		sut = ViewModelDI()
	}

	override func tearDownWithError() throws {
		sut = nil
	}

	func testContentViewModelNotNil() {
		// When
		let contentViewModel = sut.contentViewModel()
		// Then
		XCTAssertNotNil(contentViewModel)
	}

	func testSettingsViewModelNotNil() {
		// Given
		let counterSelected = CounterSelected()
		// When
		let settingsViewModel = sut.settingsViewModel(counterSelected: counterSelected)
		// Then
		XCTAssertNotNil(settingsViewModel)
	}
}
