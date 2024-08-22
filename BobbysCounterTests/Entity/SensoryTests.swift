//
//  SensoryTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 01.02.24.
//

import Testing

struct SensoryTests {
    // MARK: - Methods

    @Test("Check Sensory initializing!")
    func testSensory() {
        // Given
        let sensory: Sensory?
        // When
        sensory = Sensory()
        // Then
        #expect(sensory != nil,
                "Sensory initializing failed!")
    }

    @Test("Check Sensory feedback with error!")
    func testFeedbackWithError() {
        // Given
        let sensory = Sensory()
        // When
        sensory.feedback(feedback: .error)
        // Then
        #expect(sensory.feedback == .error &&
            sensory.feedbackBool,
            "Sensory feedback with error failed!")
    }

    @Test("Check Sensory feedback with success!")
    func testFeedbackWithSuccess() {
        // Given
        let sensory = Sensory()
        // When
        sensory.feedback(feedback: .success)
        // Then
        #expect(sensory.feedback == .success &&
            sensory.feedbackBool,
            "Sensory feedback with success failed!")
    }
}
