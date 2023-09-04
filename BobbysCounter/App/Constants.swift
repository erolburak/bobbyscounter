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

	enum Errors: CaseIterable, LocalizedError {

		// MARK: - Properties

		case reset

		var errorDescription: String? {
			switch self {
			case .reset: return String(localized: "ErrorDescription\("Reset")")
			}
		}

		var recoverySuggestion: String? {
			switch self {
			case .reset: return String(localized: "ErrorResetRecoverySuggestion")
			}
		}
	}
}
