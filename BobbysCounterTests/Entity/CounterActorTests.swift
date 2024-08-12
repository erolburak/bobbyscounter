//
//  CounterActorTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 08.08.24.
//

import Foundation
import SwiftData
import Testing

struct CounterActorTests {

	// MARK: - Actions
	
	@Test("Check CounterActor delete!")
	func testDelete() async throws {
		// Given
		let date = Calendar.current.date(byAdding: DateComponents(day: -2),
										 to: .now) ?? .now
		let id = try await CounterActor.shared.fetchID(date: date)
		// When
		try await CounterActor.shared.delete(ids: [id])
		// Then
		let modelContext = ModelContext(CounterActor.shared.modelContainer)
		let counter = try modelContext.fetch(FetchDescriptor<Counter>(predicate: #Predicate { $0.persistentModelID == id })).first
		#expect(counter == nil,
				"CounterActor delete failed!")
	}

	@Test("Check CounterActor fetchID!")
	func testFetchID() async throws {
		// Given
		let date = Calendar.current.date(byAdding: DateComponents(day: -2),
										 to: .now) ?? .now
		// When
		let id = try await CounterActor.shared.fetchID(date: date)
		// Then
		#expect(id != nil,
				"CounterActor fetchID failed!")
	}
}