//
//  SharedModelContainer.swift
//  BobbysCounter
//
//  Created by Burak Erol on 13.12.23.
//

import SwiftData

struct SharedModelContainer {

	// MARK: - Properties

	static let shared = SharedModelContainer()

	var modelContainer: ModelContainer = {
		let schema = Schema([Counter.self])
		let modelConfiguration = ModelConfiguration(schema: schema,
													isStoredInMemoryOnly: false)
		do {
			return try ModelContainer(for: schema,
									  configurations: [modelConfiguration])
		} catch {
			fatalError("Could not create model container: \(error)")
		}
	}()
}
