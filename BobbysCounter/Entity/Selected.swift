//
//  Selected.swift
//  BobbysCounter
//
//  Created by Burak Erol on 10.08.23.
//

import Foundation

@Observable
class Selected {

	// MARK: - Properties

	var average = 7
	var counter: Counter?
	var date = Date.now.toDateWithoutTime ?? .now
}
