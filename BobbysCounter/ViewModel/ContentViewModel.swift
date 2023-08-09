//
//  ContentViewModel.swift
//  BobbysCounter
//
//  Created by Burak Erol on 13.07.23.
//

import SwiftData
import SwiftUI

@Observable
class ContentViewModel {

	// MARK: - Properties

	var alertError: Constant.Errors?
	var counter: Counter?
	var selectedDate: Date = .now
	var showAlert: Bool = false
	var showSettingsSheet: Bool = false

	// MARK: - Actions

	/// Decrease counter count value if count greater than 0
	func decreaseCount() {
		Repository.shared.decreaseCount(counter: counter)
	}

	/// Increase counter count value
	func increaseCount() {
		Repository.shared.increaseCount(counter: counter)
	}

	/// Fetch counter matching selected date
	func fetchCounter() async throws {
		do {
			counter = try await Repository.shared.fetchCounter(selectedDate: selectedDate)
		} catch Constant.Errors.fetch {
			showAlert(error: .fetch)
		} catch Constant.Errors.insert {
			showAlert(error: .insert)
		}
	}

	/// Set alert error and show alert
	func showAlert(error: Constant.Errors) {
		alertError = error
		showAlert = true
	}
}
