//
//  Constants.swift
//  BobbysCounter
//
//  Created by Burak Erol on 18.07.23.
//

import Foundation

struct Constants {

	// MARK: - Properties

	static let shared = Constants()

	// MARK: - Type Definitions

	enum Errors: CaseIterable, Equatable, LocalizedError {

		// MARK: - Properties

		case error(String), reset

		static var allCases: [Errors] = [.error(String(localized: "ErrorDescription")),
										 .reset]

		var errorDescription: String? {
			switch self {
			case .error(let error):
				return error.description
			case .reset:
				return String(localized: "ErrorDescriptionReset")
			}
		}

		var recoverySuggestion: String? {
			switch self {
			case .error:
				return String(localized: "ErrorRecoverySuggestionError")
			case .reset:
				return String(localized: "ErrorRecoverySuggestionReset")
			}
		}
	}
}
