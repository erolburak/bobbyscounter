//
//  InsertCounterUseCase.swift
//  BobbysCounter
//
//  Created by Burak Erol on 02.09.23.
//

import Foundation

protocol PInsertCounterUseCase {

	// MARK: - Actions

	func insert(selectedDate: Date) -> Counter?
}

class InsertCounterUseCase: PInsertCounterUseCase {

	// MARK: - Actions

	@MainActor
	func insert(selectedDate: Date) -> Counter? {
		guard selectedDate <= .now else { return nil }
		let counter = Counter(count: 0,
							  date: selectedDate)
		DataController.shared.modelContainer.mainContext.insert(counter)
		return counter
	}
}
