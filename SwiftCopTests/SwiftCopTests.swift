//
//  SwiftCopTests.swift
//  SwiftCopTests
//
//  Created by Andres on 10/16/15.
//  Copyright © 2015 Andres Canal. All rights reserved.
//

import XCTest
@testable import SwiftCop

class SwiftCopTests: XCTestCase {
	var nameTextField: UITextField!

    override func setUp() {
        super.setUp()

		self.nameTextField = UITextField()
		self.nameTextField.text = "Not Used"
    }

    override func tearDown() {
        super.tearDown()
    }
	
	func testAddSuspect() {
		let swiftCop = SwiftCop()
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "True Trial", trial: Trial.True))
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "False Trial", trial: Trial.True))
		XCTAssertTrue(swiftCop.suspects.count == 2)
	}
	
	func testAnyGuiltyFalse() {
		let swiftCop = SwiftCop()
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "True Trial", trial: Trial.True))
		XCTAssertFalse(swiftCop.anyGuilty())
	}
	
	func testAnyGuiltyTrue() {
		let swiftCop = SwiftCop()
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "False Trial", trial: Trial.False))
		XCTAssertTrue(swiftCop.anyGuilty())
	}
	
	func testIsGuiltyTrue() {
		let swiftCop = SwiftCop()

		let textFieldNotGuilty = UITextField()
		textFieldNotGuilty.text = "Not guilty"

		let textFieldGuilty = UITextField()
		textFieldGuilty.text = "Guilty"

		swiftCop.addSuspect(Suspect(view: textFieldNotGuilty, sentence: "True Trial" , trial: Trial.True))
		swiftCop.addSuspect(Suspect(view: textFieldGuilty, sentence: "True Trial" , trial: Trial.True))
		swiftCop.addSuspect(Suspect(view: textFieldGuilty, sentence: "False Trial" , trial: Trial.False))

		let guilties = swiftCop.allGuilties()
		XCTAssertTrue(guilties.count == 1)

		XCTAssertNil(swiftCop.isGuilty(textFieldNotGuilty))
		XCTAssertNotNil(swiftCop.isGuilty(textFieldGuilty))

		let expectation = expectationWithDescription("isGuilty returns true")
		
		if let suspect = swiftCop.isGuilty(textFieldGuilty) {
			XCTAssertEqual(suspect.view, textFieldGuilty)
			XCTAssertEqual(suspect.sentence, "False Trial")
			expectation.fulfill()
		}
		
		waitForExpectationsWithTimeout(1) { error in
			
		}
	}
	
    func testCustomTrialNoTGuilty() {
		let swiftCop = SwiftCop()
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "Not Guilty") {
			(evidence: String) -> Bool in
			return true
		})

		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "Not Guilty") {
			(evidence: String) -> Bool in
			return true
		})

		XCTAssertFalse(swiftCop.anyGuilty())
    }
	
	func testCustomTrialGuilty() {
		let swiftCop = SwiftCop()
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "Guilty") {
			(evidence: String) -> Bool in
			return false
		})
		
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "Not Guilty") {
			(evidence: String) -> Bool in
			return true
		})
		
		XCTAssertTrue(swiftCop.anyGuilty())
	}

	func testCustomTrialAllGuiltiesFalse() {
		let swiftCop = SwiftCop()
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "Not Guilty", trial: Trial.True))
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "Not Guilty", trial: Trial.True))
		
		let guilties = swiftCop.allGuilties()
		XCTAssertTrue(guilties.count == 0)
	}

	func testCustomTrialAllGuiltiesTrue() {
		let swiftCop = SwiftCop()
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "Guilty", trial: Trial.False))
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "Not Guilty", trial: Trial.True))
		
		let guilties = swiftCop.allGuilties()
		XCTAssertTrue(guilties.count == 1)
		XCTAssertEqual(guilties.first!.view, self.nameTextField)
		XCTAssertEqual(guilties.first!.sentence, "Guilty")
	}

	func testNoTextTextField() {
		let swiftCop = SwiftCop()
		self.nameTextField.text = nil
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "Guilty" , trial: Trial.False))
		
		let guilties = swiftCop.allGuilties()
		XCTAssertTrue(guilties.count == 1)
	}
}
