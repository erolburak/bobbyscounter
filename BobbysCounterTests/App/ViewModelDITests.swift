//
//  ViewModelDITests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 04.09.23.
//

@testable import BobbysCounter
import XCTest

class ViewModelDITests: XCTestCase {

	// MARK: - Private Properties

	private var sut: ViewModelDI!

	// MARK: - Life Cycle

	override func setUpWithError() throws {
		sut = ViewModelDI()
	}

	override func tearDownWithError() throws {
		sut = nil
	}

	// MARK: - Actions

	func testContentViewModelIsNotNil() {
		// When
		let contentViewModel = sut.contentViewModel()
		// Then
		XCTAssertNotNil(contentViewModel)
	}

	func testSettingsViewModelIsNotNil() {
		// Given
		let counterSelected = CounterSelected()
		// When
		let settingsViewModel = sut.settingsViewModel(counterSelected: counterSelected)
		// Then
		XCTAssertNotNil(settingsViewModel)
	}
}
