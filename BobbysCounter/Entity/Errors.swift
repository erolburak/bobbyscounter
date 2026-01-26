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
    case fetch, insert
    case decrement, increment
    case categoryDuplicate, categoryEdit
    case decrementNegative, resetCount, step

    var errorDescription: String? {
        switch self {
        case .error(let error):
            error.description
        case .fetch:
            String(localized: "ErrorDescriptionFetch")
        case .insert:
            String(localized: "ErrorDescriptionInsert")
        case .decrement:
            String(localized: "ErrorDescriptionDecrement")
        case .increment:
            String(localized: "ErrorDescriptionIncrement")
        case .categoryDuplicate:
            String(localized: "ErrorDescriptionCategoryDuplicate")
        case .categoryEdit:
            String(localized: "ErrorDescriptionCategoryEdit")
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
        case .fetch:
            String(localized: "ErrorRecoverySuggestionFetch")
        case .insert:
            String(localized: "ErrorRecoverySuggestionInsert")
        case .decrement:
            String(localized: "ErrorRecoverySuggestionDecrement")
        case .increment:
            String(localized: "ErrorRecoverySuggestionIncrement")
        case .categoryDuplicate:
            String(localized: "ErrorRecoverySuggestionCategoryDuplicate")
        case .categoryEdit:
            String(localized: "ErrorRecoverySuggestionCategoryEdit")
        case .decrementNegative:
            String(localized: "ErrorRecoverySuggestionDecrementNegative")
        case .resetCount:
            String(localized: "ErrorRecoverySuggestionResetCount")
        case .step:
            String(localized: "ErrorRecoverySuggestionStep")
        }
    }
}
