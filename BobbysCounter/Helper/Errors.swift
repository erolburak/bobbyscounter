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

	var errorDescription: String? {
		switch self {
		case .error(let error):
			return error.description
		case .fetch:
			return String(localized: "ErrorDescriptionFetch")
		}
	}

	var recoverySuggestion: String? {
		switch self {
		case .error:
			return String(localized: "ErrorRecoverySuggestionError")
		case .fetch:
			return String(localized: "ErrorRecoverySuggestionFetch")
		}
	}
}
