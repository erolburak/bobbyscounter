//
//  ResetCountersUseCase.swift
//  BobbysCounter
//
//  Created by Burak Erol on 02.09.23.
//

import SwiftData

protocol PResetCountersUseCase {
	func resetCounters() throws
}

final class ResetCountersUseCase: PResetCountersUseCase {

	// MARK: - Actions

	/// Reset counters
	@MainActor
	func resetCounters() throws {
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
