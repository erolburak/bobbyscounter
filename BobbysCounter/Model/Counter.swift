//
//  Counter.swift
//  BobbysCounter
//
//  Created by Burak Erol on 27.06.23.
//

import Foundation
import SwiftData

@Model
final class Counter {

	// MARK: - Properties

	var count = 0
	var date = Date.now

	// MARK: - Life Cycle

	init(count: Int,
		 date: Date) {
		self.count = count
		self.date = date
	}
}
