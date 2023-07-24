//
//  SettingsViewModel.swift
//  BobbysCounter
//
//  Created by Burak Erol on 18.07.23.
//

import SwiftData
import SwiftUI

@Observable
class SettingsViewModel {

	// MARK: - Properties

	var alertError: Constant.Errors?
	var showAlert: Bool = false
	var showConfirmationDialog: Bool = false

	// MARK: - Actions

	/// Delete counters, reset view model properties, set counter and return object
	func reset(selectedDate: Date) async throws -> Counter? {
		do {
			try await Repository.shared.deleteCounters()
			alertError = nil
			showAlert = false
			showConfirmationDialog = false
			return try await setCounter(counters: [],
										selectedDate: selectedDate)
		} catch Constant.Errors.reset {
			showAlert(error: .reset)
		}
		return nil
	}

	/// Set counter matching selected date otherwise insert new one and return object
	func setCounter(counters: [Counter],
					selectedDate: Date) async throws -> Counter? {
		return try await Repository.shared.setCounter(counters: counters,
													  selectedDate: selectedDate)
	}

	/// Set alert error and show alert
	func showAlert(error: Constant.Errors) {
		alertError = error
		showAlert.toggle()
	}
}
