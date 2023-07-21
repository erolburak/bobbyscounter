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

	@Attribute(.unique) private let id: String
	var count: Int
	var date: Date

	// MARK: - Life Cycle

	init(count: Int,
		 date: Date) {
		self.id = UUID().uuidString
		self.count = count
		self.date = date
	}

	// MARK: - Previev

	static let preview = {
		Counter(count: 7,
				date: .now)
	}()
}
