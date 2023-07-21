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

	/// Fetch counter where date is matching today and return object
	@MainActor
	func fetchTodaysCounter(modelContext: ModelContext) throws -> Counter? {
		guard let counters = try? modelContext.fetch(Repository.fetchDescriptor),
			  let counter = counters.first(where: { $0.date.isDateToday }) else {
			throw Constant.Errors.fetch
		}
		return counter
	}

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

	/// Delete counters
	func deleteCounters(modelContext: ModelContext) throws {
		try modelContext.enumerate(Repository.fetchDescriptor) { counter in
			modelContext.delete(counter)
		}
	}

	/// Set counter matching selected date otherwise insert new counter and return object
	func setCounter(counters: [Counter],
					selectedDate: Date,
					modelContext: ModelContext) -> Counter? {
		guard let counter = counters.first(where: { Calendar.current.isDate($0.date,
																	 inSameDayAs: selectedDate) }) else {
			return insertCounter(selectedDate: selectedDate,
								 modelContext: modelContext)
		}
		return counter
	}

	/// Insert new counter and return new object
	private func insertCounter(selectedDate: Date,
					   modelContext: ModelContext) -> Counter {
		let counter = Counter(count: 0,
							  date: selectedDate)
		modelContext.insert(counter)
		return counter
	}
}
