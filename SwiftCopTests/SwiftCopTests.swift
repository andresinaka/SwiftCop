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
	var emailTextField: UITextField!


    override func setUp() {
        super.setUp()

		self.nameTextField = UITextField()
		self.nameTextField.text = "Not Used"
		
		self.emailTextField = UITextField()
		self.emailTextField.text = "Not Used"
    }

    override func tearDown() {
        super.tearDown()
    }
	
	func testAddSuspect() {
		let swiftCop = SwiftCop()
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "True Trial", trial: Trial.beTrue))
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "False Trial", trial: Trial.beFalse))
		XCTAssertTrue(swiftCop.suspects.count == 2)
	}
	
	func testAnyGuiltyFalse() {
		let swiftCop = SwiftCop()
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "True Trial", trial: Trial.beTrue))
		XCTAssertFalse(swiftCop.anyGuilty())
	}
	
	func testAnyGuiltyTrue() {
		let swiftCop = SwiftCop()
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "False Trial", trial: Trial.beFalse))
		XCTAssertTrue(swiftCop.anyGuilty())
	}
	
	func testIsGuiltyTrue() {
		let swiftCop = SwiftCop()

		let textFieldNotGuilty = UITextField()
		textFieldNotGuilty.text = "Not guilty"

		let textFieldGuilty = UITextField()
		textFieldGuilty.text = "Guilty"

		swiftCop.addSuspect(Suspect(view: textFieldNotGuilty, sentence: "True Trial" , trial: Trial.beTrue))
		swiftCop.addSuspect(Suspect(view: textFieldGuilty, sentence: "True Trial" , trial: Trial.beTrue))
		swiftCop.addSuspect(Suspect(view: textFieldGuilty, sentence: "False Trial" , trial: Trial.beFalse))

		let guilties = swiftCop.allGuilties()
		XCTAssertTrue(guilties.count == 1)

		XCTAssertNil(swiftCop.isGuilty(textFieldNotGuilty))
		XCTAssertNotNil(swiftCop.isGuilty(textFieldGuilty))

		let expectation = self.expectation(description: "isGuilty returns true")
		
		if let suspect = swiftCop.isGuilty(textFieldGuilty) {
			XCTAssertEqual(suspect.view, textFieldGuilty)
			XCTAssertEqual(suspect.verdict(), "False Trial")
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 1) { error in
			
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
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "Not Guilty", trial: Trial.beTrue))
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "Not Guilty", trial: Trial.beTrue))
		
		let guilties = swiftCop.allGuilties()
		XCTAssertTrue(guilties.count == 0)
	}

	func testCustomTrialAllGuiltiesTrue() {
		let swiftCop = SwiftCop()
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "Guilty", trial: Trial.beFalse))
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "Not Guilty", trial: Trial.beTrue))
		
		let guilties = swiftCop.allGuilties()
		XCTAssertTrue(guilties.count == 1)
		XCTAssertEqual(guilties.first!.view, self.nameTextField)
		XCTAssertEqual(guilties.first!.verdict(), "Guilty")
	}

	func testNoTextTextField() {
		let swiftCop = SwiftCop()
		self.nameTextField.text = nil
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "Guilty" , trial: Trial.beFalse))
		
		let guilties = swiftCop.allGuilties()
		XCTAssertTrue(guilties.count == 1)
	}
}
