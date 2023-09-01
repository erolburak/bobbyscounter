//
//  CounterSelectedModel.swift
//  BobbysCounter
//
//  Created by Burak Erol on 10.08.23.
//

import Foundation

@Observable
class CounterSelectedModel {

	// MARK: - Properties

	var counter: Counter?
	var selectedDate: Date = .now
}
