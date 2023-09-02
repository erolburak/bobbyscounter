//
//  IncreaseCounterCountUseCase.swift
//  BobbysCounter
//
//  Created by Burak Erol on 02.09.23.
//

protocol PIncreaseCounterCountUseCase: Sendable {
	func increase(counter: Counter?)
}

final class IncreaseCounterCountUseCase: PIncreaseCounterCountUseCase {

	// MARK: - Actions

	/// Increase counter count value
	func increase(counter: Counter?) {
		if let counter {
			counter.count += 1
		}
	}
}
