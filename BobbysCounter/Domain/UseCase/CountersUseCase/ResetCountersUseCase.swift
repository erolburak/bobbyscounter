//
//  ResetCountersUseCase.swift
//  BobbysCounter
//
//  Created by Burak Erol on 02.09.23.
//

import SwiftData

protocol PResetCountersUseCase {
	func reset() throws
}

class ResetCountersUseCase: PResetCountersUseCase {

	// MARK: - Actions

	@MainActor
	func reset() throws {
		do {
			let mainContext = DataController.shared.modelContainer.mainContext
			try mainContext.enumerate(FetchDescriptor<Counter>()) { counter in
				mainContext.delete(counter)
			}
		} catch {
			throw Constants.Errors.reset
		}
	}
}
