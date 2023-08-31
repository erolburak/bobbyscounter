//
//  Constant.swift
//  Shared
//
//  Created by Burak Erol on 18.07.23.
//

import Foundation

class Constant {

	// MARK: - Properties

	static let shared = Constant()

	// MARK: - Type Definitions

	enum Errors: CaseIterable, LocalizedError {
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
