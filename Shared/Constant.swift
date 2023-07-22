//
//  Constant.swift
//  BobbysCounter
//
//  Created by Burak Erol on 18.07.23.
//

import SwiftData
import SwiftUI

class Constant {

	// MARK: - Properties

	static let shared = Constant()

	// MARK: - Type Definitions

	enum Errors: LocalizedError {
		case fetch, insert, reset

		var errorDescription: String? {
			switch self {
			case .fetch: return String(localized: "ErrorDescription\("Fetch")")
			case .insert: return String(localized: "ErrorDescription\("Insert")")
			case .reset: return String(localized: "ErrorDescription\("Reset")")
			}
		}

		var recoverySuggestion: String? {
			switch self {
			case .fetch: return String(localized: "ErrorFetchRecoverySuggestion")
			case .insert: return String(localized: "ErrorInsertRecoverySuggestion")
			case .reset: return String(localized: "ErrorResetRecoverySuggestion")
			}
		}
	}
}
