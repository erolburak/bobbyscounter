//
//  CounterTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 05.09.23.
//

@testable import BobbysCounter
import XCTest

class CounterTests: XCTestCase {

	// MARK: - Actions
	
	func testCounter() async {
		// Given
		let counter: Counter?
		// When
		counter = Counter(count: 0,
						  date: .now)
		// Then
		XCTAssertNotNil(counter)
	}
}
