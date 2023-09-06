//
//  ResetCountersUseCaseTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 02.09.23.
//

@testable import BobbysCounter
import XCTest

class ResetCountersUseCaseTests: XCTestCase {

	// MARK: - Private Properties

	private var sut: ResetCountersUseCase!

	// MARK: - Life Cycle

	override func setUpWithError() throws {
		sut = ResetCountersUseCase()
	}

	override func tearDownWithError() throws {
		sut = nil
	}

	// MARK: - Actions

	@MainActor
	func testResetNotThrows() {
		XCTAssertNoThrow(try sut.reset())
	}
}
