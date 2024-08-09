//
//  SensoryTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 01.02.24.
//

@testable import BobbysCounter
import Testing

struct SensoryTests {

	// MARK: - Actions

	@Test("Check initializing Sensory!")
	func testSensory() {
		// Given
		let sensory: Sensory?
		// When
		sensory = Sensory()
		// Then
		#expect(sensory != nil,
				"Initializing Sensory failed!")
	}

	@Test("Check feedback trigger with success!")
	func testFeedbackTrigger() {
		// Given
		let sensory = Sensory()
		// When
		sensory.feedbackTrigger(feedback: .success)
		// Then
		#expect(sensory.feedback == .success,
				"Feedback trigger with success failed!")
		#expect(sensory.feedbackBool,
				"Feedback trigger failed!")
	}
}
