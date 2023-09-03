//
//  DataController.swift
//  BobbysCounter
//
//  Created by Burak Erol on 18.07.23.
//

import SwiftData

class DataController {

	// MARK: - Properties

	static let shared = DataController()
	lazy var modelContainer = getModelContainer()

	// MARK: - Actions

	func updateModelContainer() {
		modelContainer = getModelContainer()
	}

	private func getModelContainer() -> ModelContainer {
		do {
			return try ModelContainer(for: Counter.self)
		} catch {
			fatalError("Could not get model container: \(error)")
		}
	}
}
