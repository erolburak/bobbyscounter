//
//  DecreaseCounterCountUseCase.swift
//  BobbysCounter
//
//  Created by Burak Erol on 02.09.23.
//

protocol PDecreaseCounterCountUseCase {
	func decrease(counter: Counter?)
}

class DecreaseCounterCountUseCase: PDecreaseCounterCountUseCase {

	// MARK: - Actions

	func decrease(counter: Counter?) {
		if let counter,
		   counter.count > 0 {
			counter.count -= 1
		}
	}
}
