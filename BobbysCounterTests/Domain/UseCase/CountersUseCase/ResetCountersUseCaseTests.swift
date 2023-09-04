//
//  ResetCountersUseCaseTests.swift
//  BobbysCounterTests
//
//  Created by Burak Erol on 02.09.23.
//

@testable import BobbysCounter
import XCTest

class ResetCountersUseCaseTests: XCTestCase {

	private var sut: ResetCountersUseCase!

	override func setUpWithError() throws {
		sut = ResetCountersUseCase()
	}

	override func tearDownWithError() throws {
		sut = nil
	}

	@MainActor
	func testResetNotThrows() {
		XCTAssertNoThrow(try sut.reset())
	}
}
