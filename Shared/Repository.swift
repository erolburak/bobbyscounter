//
//  Repository.swift
//  BobbysCounter
//
//  Created by Burak Erol on 18.07.23.
//

import SwiftData
import SwiftUI

class Repository {

	// MARK: - Properties

	static let shared = Repository()
	static let fetchDescriptor = FetchDescriptor<Counter>(sortBy: [SortDescriptor(\.date,
																				   order: .forward)])
	var modelContainer: ModelContainer? { try? ModelContainer(for: [Counter.self]) }

	/// Decrease counter count value if count greater than 0
	func decreaseCount(counter: Counter?) {
		if let counter,
		   counter.count > 0 {
			counter.count -= 1
		}
	}

	/// Increase counter count value
	func increaseCount(counter: Counter?) {
		if let counter {
			counter.count += 1
		}
	}

	/// Set counter matching selected date otherwise insert new counter and return object
	func setCounter(counters: [Counter],
					selectedDate: Date) async throws -> Counter? {
		guard let counter = counters.first(where: { Calendar.current.isDate($0.date,
																			inSameDayAs: selectedDate) }) else {
			return try await insertCounter(selectedDate: selectedDate)
		}
		return counter
	}

	/// Delete counters
	@MainActor
	func deleteCounters() throws {
		guard let modelContext = modelContainer?.mainContext else {
			throw Constant.Errors.reset
		}
		try modelContext.enumerate(Repository.fetchDescriptor) { counter in
			modelContext.delete(counter)
		}
	}

	/// Fetch counter where date is matching today and return object
	@MainActor
	func fetchTodaysCounter() throws -> Counter? {
		guard let modelContext = modelContainer?.mainContext,
			  let counters = try? modelContext.fetch(Repository.fetchDescriptor),
			  let counter = counters.first(where: { $0.date.isDateToday }) else {
			throw Constant.Errors.fetch
		}
		return counter
	}

	/// Insert new counter and return new object
	@MainActor
	private func insertCounter(selectedDate: Date) throws -> Counter {
		guard let modelContext = modelContainer?.mainContext else {
			throw Constant.Errors.insert
		}
		let counter = Counter(count: 0,
							  date: selectedDate)
		modelContext.insert(counter)
		return counter
	}
}
