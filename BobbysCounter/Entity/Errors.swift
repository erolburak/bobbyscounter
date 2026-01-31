//
//  Errors.swift
//  BobbysCounter
//
//  Created by Burak Erol on 18.07.23.
//

import Foundation

enum Errors: LocalizedError {
    // MARK: - Properties

    case error(String)
    case addCategory, addCounter, editCategory, fetch, fetchWidget
    case decrement, increment
    case decrementNegative, resetCount, step

    var errorDescription: String? {
        switch self {
        case .error(let error):
            error.description
        case .addCategory:
            String(localized: "ErrorDescriptionAddCategory")
        case .addCounter:
            String(localized: "ErrorDescriptionAddCounter")
        case .editCategory:
            String(localized: "ErrorDescriptionEditCategory")
        case .fetch:
            String(localized: "ErrorDescriptionFetch")
        case .fetchWidget:
            String(localized: "ErrorDescriptionFetchWidget")
        case .decrement:
            String(localized: "ErrorDescriptionDecrement")
        case .increment:
            String(localized: "ErrorDescriptionIncrement")
        case .decrementNegative:
            String(localized: "ErrorDescriptionDecrementNegative")
        case .resetCount:
            String(localized: "ErrorDescriptionResetCount")
        case .step:
            String(localized: "ErrorDescriptionStep")
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .error:
            String(localized: "ErrorRecoverySuggestionError")
        case .addCategory:
            String(localized: "ErrorRecoverySuggestionAddCategory")
        case .addCounter:
            String(localized: "ErrorRecoverySuggestionAddCounter")
        case .editCategory:
            String(localized: "ErrorRecoverySuggestionEditCategory")
        case .fetch:
            String(localized: "ErrorRecoverySuggestionFetch")
        case .fetchWidget:
            String(localized: "ErrorRecoverySuggestionFetchWidget")
        case .decrement:
            String(localized: "ErrorRecoverySuggestionDecrement")
        case .increment:
            String(localized: "ErrorRecoverySuggestionIncrement")
        case .decrementNegative:
            String(localized: "ErrorRecoverySuggestionDecrementNegative")
        case .resetCount:
            String(localized: "ErrorRecoverySuggestionResetCount")
        case .step:
            String(localized: "ErrorRecoverySuggestionStep")
        }
    }
}
