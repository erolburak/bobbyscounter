//
//  SensoryTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 01.02.24.
//

@testable import BobbysCounter
import XCTest

class SensoryTests: XCTestCase {

	// MARK: - Actions

	func testSensory() {
		// Given
		let sensory: Sensory?
		// When
		sensory = Sensory()
		// Then
		XCTAssertNotNil(sensory)
	}

	func testFeedbackTrigger() {
		// Given
		let sensory = Sensory()
		// When
		sensory.feedbackTrigger(feedback: .success)
		// Then
		XCTAssertEqual(sensory.feedback, .success)
		XCTAssertTrue(sensory.feedbackBool)
	}
}
