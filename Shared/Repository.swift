//
//  Repository.swift
//  Shared
//
//  Created by Burak Erol on 18.07.23.
//

import Foundation
import SwiftData


class Repository {

	// MARK: - Properties

	static let shared = Repository()
	private let fetchDescriptor = FetchDescriptor<Counter>()
	private var modelContainer: ModelContainer? { try? ModelContainer(for: Counter.self) }

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
	@MainActor
	func deleteCounters() throws {
		guard let modelContext = modelContainer?.mainContext else {
			throw Constant.Errors.reset
		}
		try modelContext.enumerate(fetchDescriptor) { counter in
			modelContext.delete(counter)
		}
	}

	/// Fetch counter matching selected date otherwise insert new counter and return object
	@MainActor
	func fetchCounter(selectedDate: Date) throws -> Counter {
		do {
			let counter = try? modelContainer?.mainContext.fetch(fetchDescriptor).first { Calendar.current.isDate($0.date,
																												  inSameDayAs: selectedDate) }
			guard let counter else {
				return try insertCounter(selectedDate: selectedDate)
			}
			return counter
		} catch Constant.Errors.fetch {
			throw Constant.Errors.fetch
		} catch Constant.Errors.insert {
			throw Constant.Errors.insert
		}
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
