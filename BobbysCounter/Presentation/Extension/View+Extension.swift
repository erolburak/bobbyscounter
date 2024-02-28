//
//  View+Extension.swift
//  BobbysCounter
//
//  Created by Burak Erol on 28.02.24.
//

import SwiftData
import SwiftUI

extension View {

	func modelContainer(inMemory: Bool = false) -> some View {
		modifier(ModelContainerViewModifier(inMemory: inMemory))
	}
}

private struct ModelContainerViewModifier: ViewModifier {

	// MARK: - Private Properties

	private let modelContainer: ModelContainer

	// MARK: - Inits

	init(inMemory: Bool) {
		do {
			/// Disable cloud kit database if test scheme is running
			let isTestScheme = ProcessInfo().environment["XCTestConfigurationFilePath"] != nil
			let modelConfiguration = ModelConfiguration(isStoredInMemoryOnly: false,
														cloudKitDatabase: isTestScheme ? .none : .automatic)
			modelContainer = try ModelContainer(for: Schema([Counter.self]),
												configurations: modelConfiguration)
		} catch {
			fatalError("Could not create model container: \(error)")
		}
	}

	// MARK: - Layouts

	func body(content: Content) -> some View {
		content
			.modelContainer(modelContainer)
	}
}
