//
//  InsertCounterUseCase.swift
//  BobbysCounter
//
//  Created by Burak Erol on 02.09.23.
//

import Foundation

protocol PInsertCounterUseCase {
	func insertCounter(selectedDate: Date) -> Counter
}

class InsertCounterUseCase: PInsertCounterUseCase {

	// MARK: - Actions

	/// Insert new counter and return new object
	@MainActor
	func insertCounter(selectedDate: Date) -> Counter {
		let counter = Counter(count: 0,
							  date: selectedDate)
		DataController.shared.modelContainer.mainContext.insert(counter)
		return counter
	}
}
