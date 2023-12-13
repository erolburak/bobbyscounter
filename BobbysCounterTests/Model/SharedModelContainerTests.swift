//
//  SharedModelContainerTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 13.12.23.
//

@testable import BobbysCounter
import XCTest

class SharedModelContainerTests: XCTestCase {

	// MARK: - Actions

	func testSharedModelContainer() {
		// Given
		let sharedModelContainer: SharedModelContainer?
		// When
		sharedModelContainer = SharedModelContainer()
		// Then
		XCTAssertNotNil(sharedModelContainer)
	}
}
