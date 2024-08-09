//
//  CounterActorTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 08.08.24.
//

@testable import BobbysCounter
import Foundation
import SwiftData
import Testing

struct CounterActorTests {

	// MARK: - Actions
	
	@Test("Check CounterActor delete!")
	func testDelete() async throws {
		// Given
		let counter = Counter(count: 0,
							  date: .now)
		let modelContext = ModelContext(CounterActor.shared.modelContainer)
		modelContext.insert(counter)
		try modelContext.save()
		// When
		try await CounterActor.shared.delete(persistentIdentifiers: [counter.persistentModelID])
		// Then
		let persistentIdentifier = try await CounterActor.shared.fetch(date: .now)
		#expect(persistentIdentifier != counter.persistentModelID,
				"CounterActor delete failed!")
	}

	@Test("Check CounterActor fetch!")
	func testFetch() async throws {
		// Given
		let date = Calendar.current.date(byAdding: DateComponents(day: -2),
										 to: .now) ?? .now
		let counter = Counter(count: 0,
							  date: date)
		let modelContext = ModelContext(CounterActor.shared.modelContainer)
		modelContext.insert(counter)
		try modelContext.save()
		// When
		let persistentIdentifier = try await CounterActor.shared.fetch(date: date)
		// Then
		#expect(persistentIdentifier != nil,
				"CounterActor fetch failed!")
	}
}
