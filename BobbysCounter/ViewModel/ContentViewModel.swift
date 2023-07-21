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

	/// Set counter matching selected date otherwise insert new one
	func setCounter(counters: [Counter],
					modelContext: ModelContext) {
		counter = Repository.shared.setCounter(counters: counters,
											   selectedDate: selectedDate,
											   modelContext: modelContext)
	}

	/// Fetch counter where date is matching today and overwrite
	@MainActor
	func fetchAndOverwriteTodaysCounter(counters: [Counter],
										modelContext: ModelContext) throws {
		Task {
			do {
				guard let fetchedCounter = try? Repository.shared.fetchTodaysCounter(modelContext: modelContext) else {
					throw Constant.Errors.fetch
				}
				let oldCounter = counters.first { $0.id == fetchedCounter.id }
				oldCounter?.count = fetchedCounter.count
				counter = fetchedCounter
			} catch Constant.Errors.fetch {
				alertError = .fetch
				showAlert.toggle()
			}
		}
	}
}
