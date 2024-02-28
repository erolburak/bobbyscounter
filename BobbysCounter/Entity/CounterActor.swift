//
//  CounterActor.swift
//  BobbysCounter
//
//  Created by Burak Erol on 28.02.24.
//

import Foundation
import SwiftData

@ModelActor
actor CounterActor {

	// MARK: - Properties

	nonisolated(unsafe) static var shared: CounterActor!

	// MARK: - Actions

	static func createSharedInstance(modelContext: ModelContext) {
		shared = CounterActor(modelContainer: modelContext.container)
	}

	func delete(counters: [Counter]) {
		counters.forEach { counter in
			counter.modelContext?.delete(counter)
		}
	}

	func fetch(date: Date) throws -> Counter {
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
		delete(counters: Array(duplicateCounters))
		return counter
	}
}
