//
//  DecreaseCounterCountUseCase.swift
//  BobbysCounter
//
//  Created by Burak Erol on 02.09.23.
//

protocol PDecreaseCounterCountUseCase: Sendable {
	func decreaseCount(counter: Counter?)
}

final class DecreaseCounterCountUseCase: PDecreaseCounterCountUseCase {

	// MARK: - Actions

	/// Decrease counter count value if count greater than 0
	func decreaseCount(counter: Counter?) {
		if let counter,
		   counter.count > 0 {
			counter.count -= 1
		}
	}
}
