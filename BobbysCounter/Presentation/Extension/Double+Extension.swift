//
//  Double+Extension.swift
//  BobbysCounter
//
//  Created by Burak Erol on 16.01.24.
//

import Foundation

extension Double {
    // MARK: - Private Properties

    private static let numberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = .zero
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }()

    // MARK: - Properties

    /// Formats double to string without trailing zeros and maximum 2 fraction digits
    var toString: String {
        String(Double.numberFormatter.string(from: NSNumber(value: self)) ?? "")
    }
}
