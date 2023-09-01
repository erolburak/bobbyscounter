//
//  DataController.swift
//  Shared
//
//  Created by Burak Erol on 18.07.23.
//

import Foundation
import SwiftData

class DataController {

	// MARK: - Properties

	static let shared = DataController()
	lazy var modelContainer: ModelContainer = getModelContainer()

	// MARK: - Private Properties

	private let fetchDescriptor = FetchDescriptor<Counter>()

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

	/// Fetch counter matching selected date otherwise insert new counter and return object
	@MainActor
	func fetchCounter(selectedDate: Date) -> Counter {
		let counter = try? modelContainer.mainContext.fetch(fetchDescriptor).first { Calendar.current.isDate($0.date,
																											 inSameDayAs: selectedDate) }
		guard let counter else {
			return insertCounter(selectedDate: selectedDate)
		}
		return counter
	}

	/// Reset counters
	@MainActor
	func resetCounters() throws {
		do {
			try modelContainer.mainContext.enumerate(fetchDescriptor) { counter in
				modelContainer.mainContext.delete(counter)
			}
		} catch {
			throw Constants.Errors.reset
		}
	}

	/// Insert new counter and return new object
	@MainActor
	private func insertCounter(selectedDate: Date) -> Counter {
		let counter = Counter(count: 0,
							  date: selectedDate)
		modelContainer.mainContext.insert(counter)
		return counter
	}

	/// Update model container
	func updateModelContainer() {
		modelContainer = getModelContainer()
	}

	/// Get model container and return object
	private func getModelContainer() -> ModelContainer {
		do {
			return try ModelContainer(for: Counter.self)
		} catch {
			fatalError("Could not get model container: \(error)")
		}
	}
}
