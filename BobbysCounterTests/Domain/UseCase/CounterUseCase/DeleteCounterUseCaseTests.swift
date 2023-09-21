//
//  DeleteCounterUseCaseTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 21.09.23.
//

@testable import BobbysCounter
import XCTest
import SwiftData

class DeleteCounterUseCaseTests: XCTestCase {

	// MARK: - Private Properties

	private var sut: DeleteCounterUseCase!

	// MARK: - Life Cycle

	override func setUpWithError() throws {
		sut = DeleteCounterUseCase()
	}

	override func tearDownWithError() throws {
		sut = nil
	}

	// MARK: - Actions

	@MainActor
	func testDelete() throws {
		// Given
		let counter = Counter(count: 0,
							  date: .now)
		DataController.shared.modelContainer.mainContext.insert(counter)
		// When
		sut.delete(counter: counter)
		let fetchedCounter = try DataController.shared.modelContainer.mainContext.fetch(FetchDescriptor<Counter>()).first { $0 == counter }
		// Then
		XCTAssertNil(fetchedCounter)
	}
}
