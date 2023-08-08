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

	/// Fetch counter count value matching todays counter otherwise return 0
	func fetchCount() async throws -> Int {
		do {
			return try await Repository.shared.fetchTodaysCounter()?.count ?? 0
		} catch Constant.Errors.fetch {
			showAlert(error: .fetch)
			return 0
		}
	}

	/// Set counter matching selected date otherwise insert new one
	func setCounter(counters: [Counter]) async throws {
		do {
			counter = try await Repository.shared.setCounter(counters: counters,
															 selectedDate: selectedDate)
		} catch Constant.Errors.insert {
			showAlert(error: .insert)
		}
	}

	/// Set alert error and show alert
	func showAlert(error: Constant.Errors) {
		alertError = error
		showAlert.toggle()
	}
}
