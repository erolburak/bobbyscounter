//
//  Counter+Extensions.swift
//  BobbysCounter
//
//  Created by Burak Erol on 13.12.23.
//

import Foundation
import SwiftData

extension Counter {

	// MARK: - Properties

	static let modelContainer: ModelContainer = {
		do {
			return try ModelContainer(for: Schema([Counter.self]),
									  configurations: ModelConfiguration(isStoredInMemoryOnly: false))
		} catch {
			fatalError("Could not create model container: \(error)")
		}
	}()

	// MARK: - Actions

	func delete() {
		self.modelContext?.delete(self)
	}

	@discardableResult
	static func fetch(date: Date) throws -> Counter {
		let modelContext = ModelContext(modelContainer)
		let counters = try modelContext.fetch(FetchDescriptor<Counter>(predicate: #Predicate { $0.date == date.toDateWithoutTime }))
		/// Insert new counter if no counter with given date exists
		guard let counter = counters.first else {
			let newCounter = Counter(count: 0,
									 date: date)
			modelContext.insert(newCounter)
			return newCounter
		}
		/// Delete duplicate counters while initializing new array without first item in counters array
		let duplicateCounters = counters.dropFirst()
		duplicateCounters.forEach { counter in
			counter.delete()
		}
		return counter
	}
}
