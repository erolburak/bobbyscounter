//
//  Errors.swift
//  BobbysCounter
//
//  Created by Burak Erol on 18.07.23.
//

import Foundation

enum Errors: LocalizedError {
    // MARK: - Properties

    case error(String), fetch
    case decrease, increase

    var errorDescription: String? {
        switch self {
        case let .error(error):
            error.description
        case .fetch:
            String(localized: "ErrorDescriptionFetch")
        case .decrease:
            String(localized: "ErrorDescriptionDecrease")
        case .increase:
            String(localized: "ErrorDescriptionIncrease")
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .error:
            String(localized: "ErrorRecoverySuggestionError")
        case .fetch:
            String(localized: "ErrorRecoverySuggestionFetch")
        case .decrease:
            String(localized: "ErrorRecoverySuggestionDecrease")
        case .increase:
            String(localized: "ErrorRecoverySuggestionIncrease")
        }
    }
}
