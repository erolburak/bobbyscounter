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

	static let shared = {
		do {
			/// Disable cloud kit database if test scheme is running
			let isTestScheme = ProcessInfo().environment["XCTestConfigurationFilePath"] != nil
			let modelConfiguration = ModelConfiguration(isStoredInMemoryOnly: false,
														cloudKitDatabase: isTestScheme ? .none : .automatic)
			let modelContainer = try ModelContainer(for: Schema([Counter.self]),
													configurations: modelConfiguration)
			return CounterActor(modelContainer: modelContainer)
		} catch {
			fatalError("Could not create model container: \(error)")
		}
	}()

	// MARK: - Actions

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
