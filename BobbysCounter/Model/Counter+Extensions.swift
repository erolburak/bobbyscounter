//
//  Counter+Extensions.swift
//  BobbysCounter
//
//  Created by Burak Erol on 13.12.23.
//

import Foundation
import SwiftData

extension Counter {

	// MARK: - Actions

	func delete(_ modelContext: ModelContext) {
		modelContext.delete(self)
	}

	static func fetch(_ modelContext: ModelContext,
					   date: Date) throws -> Counter {
		let counters = try modelContext.fetch(FetchDescriptor<Counter>())
		let counter = counters.first { Calendar.current.isDate($0.date,
															   inSameDayAs: date) }
		guard let counter else {
			let newCounter = Counter(count: 0,
									 date: date)
			modelContext.insert(newCounter)
			return newCounter
		}
		return counter
	}
}
