//
//  Sensory.swift
//  BobbysCounter
//
//  Created by Burak Erol on 01.02.24.
//

import SwiftUI

@Observable
class Sensory {

	// MARK: - Properties

	var feedback: SensoryFeedback?
	var feedbackTrigger = false

	// MARK: - Properties

	func trigger(_ feedback: SensoryFeedback) {
		self.feedback = feedback
		feedbackTrigger.toggle()
	}
}
