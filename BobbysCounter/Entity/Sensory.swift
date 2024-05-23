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
	var feedbackBool = false

	// MARK: - Actions

	func feedbackTrigger(feedback: SensoryFeedback) {
		self.feedback = feedback
		feedbackBool.toggle()
	}
}
