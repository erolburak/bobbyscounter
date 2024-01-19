//
//  BobbysCounterUITestsLaunchTests.swift
//  BobbysCounterUITests
//
//  Created by Burak Erol on 27.06.23.
//

import XCTest

final class BobbysCounterUITestsLaunchTests: XCTestCase {

	// MARK: - Actions

	override class var runsForEachTargetApplicationUIConfiguration: Bool {
		true
	}

	override func setUpWithError() throws {
		continueAfterFailure = false
	}

	func testLaunch() throws {
		let app = XCUIApplication()
		app.launch()
		let attachment = XCTAttachment(screenshot: app.screenshot())
		attachment.name = "Launch Screen"
		attachment.lifetime = .keepAlways
		add(attachment)
	}
}
