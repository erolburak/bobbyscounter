//
//  FetchCounterUseCase.swift
//  BobbysCounter
//
//  Created by Burak Erol on 02.09.23.
//

import Foundation
import SwiftData

protocol PFetchCounterUseCase: Sendable {

	// MARK: - Actions

	func fetch(selectedDate: Date) -> Counter?
}

final class FetchCounterUseCase: PFetchCounterUseCase {

	// MARK: - Actions

	@MainActor
	func fetch(selectedDate: Date) -> Counter? {
		try? DataController.shared.modelContainer.mainContext.fetch(FetchDescriptor<Counter>()).first { Calendar.current.isDate($0.date,
																																inSameDayAs: selectedDate) }
	}
}
