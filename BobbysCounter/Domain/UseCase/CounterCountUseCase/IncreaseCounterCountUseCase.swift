//
//  IncreaseCounterCountUseCase.swift
//  BobbysCounter
//
//  Created by Burak Erol on 02.09.23.
//

protocol PIncreaseCounterCountUseCase {
	func increase(counter: Counter?)
}

class IncreaseCounterCountUseCase: PIncreaseCounterCountUseCase {

	// MARK: - Actions

	func increase(counter: Counter?) {
		if let counter {
			counter.count += 1
		}
	}
}
