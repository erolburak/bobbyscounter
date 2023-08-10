//
//  CounterSelected.swift
//  BobbysCounter
//
//  Created by Burak Erol on 10.08.23.
//

import Foundation

@Observable
class CounterSelected {

	// MARK: - Properties

	var counter: Counter?
	var selectedDate: Date = .now
}
