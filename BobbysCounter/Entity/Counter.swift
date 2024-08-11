//
//  Counter.swift
//  BobbysCounter
//
//  Created by Burak Erol on 27.06.23.
//

import Foundation
import SwiftData

@Model
final class Counter {

	// MARK: - Properties

	var count = 0
	var date: Date?

	// MARK: - Inits

	init(count: Int,
		 date: Date) {
		self.count = count
		self.date = date.toDateWithoutTime
	}

	// MARK: - Actions

	func decrease() throws {
		if count > 0 {
			count -= 1
			try modelContext?.save()
		}
	}

	func increase() throws {
		count += 1
		try modelContext?.save()
	}

	@MainActor
	static func fetch(date: Date) async throws -> Counter? {
		let id = try await CounterActor.shared.fetchID(date: date)
		let modelContext = ModelContext(CounterActor.shared.modelContainer)
		return modelContext.model(for: id) as? Counter
	}
}
