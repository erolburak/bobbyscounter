//
//  Double+Extensions.swift
//  BobbysCounter
//
//  Created by Burak Erol on 16.01.24.
//

import Foundation

extension Double {

	// MARK: - Properties

	/// Formats double to string without trailing zeros and maximum 2 fraction digits
	var toString: String {
		let formatter = NumberFormatter()
		let number = NSNumber(value: self)
		formatter.minimumFractionDigits = 0
		formatter.maximumFractionDigits = 2
		return String(formatter.string(from: number) ?? "")
	}
}
