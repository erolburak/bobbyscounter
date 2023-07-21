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
	func reset(selectedDate: Date,
			   modelContext: ModelContext) -> Counter? {
		do {
			try Repository.shared.deleteCounters(modelContext: modelContext)
			alertError = nil
			showAlert = false
			showConfirmationDialog = false
			return setCounter(counters: [],
							  selectedDate: selectedDate,
							  modelContext: modelContext)
		} catch {
			alertError = .reset
			showAlert.toggle()
		}
		return nil
	}

	/// Set counter matching selected date otherwise insert new one and return object
	func setCounter(counters: [Counter],
					selectedDate: Date,
					modelContext: ModelContext) -> Counter? {
		return Repository.shared.setCounter(counters: counters,
											selectedDate: selectedDate,
											modelContext: modelContext)
	}
}
