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

    // MARK: - Methods

    func feedback(_ feedback: SensoryFeedback) {
        self.feedback = feedback
        feedbackBool.toggle()
    }
}
