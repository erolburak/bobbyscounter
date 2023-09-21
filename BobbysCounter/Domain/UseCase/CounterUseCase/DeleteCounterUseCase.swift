//
//  DeleteCounterUseCase.swift
//  BobbysCounter
//
//  Created by Burak Erol on 21.09.23.
//

protocol PDeleteCounterUseCase {

	// MARK: - Actions

	func delete(counter: Counter)
}

class DeleteCounterUseCase: PDeleteCounterUseCase {

	// MARK: - Actions

	@MainActor
	func delete(counter: Counter) {
		DataController.shared.modelContainer.mainContext.delete(counter)
	}
}
