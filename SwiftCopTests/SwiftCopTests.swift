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
		self.nameTextField.text = "Billy Joel"
    }

    override func tearDown() {
        super.tearDown()
    }

    func testCustomTrialNoGuilties() {
		let swiftCop = SwiftCop()
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "More than five characters") {
			return $0.characters.count >= 5
		})

		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "Two words") {
			return $0.componentsSeparatedByString(" ").filter{$0 != ""}.count >= 2
		})

		XCTAssertFalse(swiftCop.anyGuilty())
    }
	
	func testCustomTrialGuilties() {
		let swiftCop = SwiftCop()
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "Two characters") {
			return $0.characters.count == 2
		})

		XCTAssertTrue(swiftCop.anyGuilty())
	}
	
	func testCustomTrialAllGuilties() {
		let swiftCop = SwiftCop()
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "More than five characters") {
			return $0.characters.count >= 5
		})
		
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "Two words") {
			return $0.componentsSeparatedByString(" ").filter{$0 != ""}.count >= 2
		})
		
		let guilties = swiftCop.allGuilties()
		XCTAssertTrue(guilties.count == 0)
	}
	
	func testCustomTrialAllGuiltiesOneFail() {
		let swiftCop = SwiftCop()
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "More than five characters") {
			return $0.characters.count >= 5
		})
		
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "Three words") {
			return $0.componentsSeparatedByString(" ").count >= 3
		})
		
		let guilties = swiftCop.allGuilties()
		XCTAssertTrue(guilties.count == 1)
		XCTAssertEqual(guilties.first!.view, self.nameTextField)
		XCTAssertEqual(guilties.first!.sentence, "Three words")
	}
	
	func testTrialValidationPass() {
		let swiftCop = SwiftCop()
		self.nameTextField.text = "email@email.com"
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "Invalid Email" , trial: Trial.Email))

		let guilties = swiftCop.allGuilties()
		XCTAssertTrue(guilties.count == 0)
	}
	
	func testTrialValidationGuilty() {
		let swiftCop = SwiftCop()
		self.nameTextField.text = "email@email"
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "Invalid Email" , trial: Trial.Email))
		
		let guilties = swiftCop.allGuilties()
		XCTAssertTrue(guilties.count == 1)
	}
	
	func testNoTextTextField() {
		let swiftCop = SwiftCop()
		self.nameTextField.text = nil
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "Invalid Email" , trial: Trial.Email))
		
		let guilties = swiftCop.allGuilties()
		XCTAssertTrue(guilties.count == 1)
	}
	
	func testIsGuilty() {
		let swiftCop = SwiftCop()
		let textField1 = UITextField()
		textField1.text = "test@test.com"
		
		let textField2 = UITextField()
		textField2.text = "wrong"

		swiftCop.addSuspect(Suspect(view: textField1, sentence: "Invalid Email" , trial: Trial.Email))
		swiftCop.addSuspect(Suspect(view: textField2, sentence: "Invalid Email" , trial: Trial.Email))
		swiftCop.addSuspect(Suspect(view: textField2, sentence: "Not Long Enought" , trial: Trial.Length(.Minimum, 2)))

		let guilties = swiftCop.allGuilties()
		XCTAssertTrue(guilties.count == 1)
		
		XCTAssertNil(swiftCop.isGuilty(textField1))
		XCTAssertNotNil(swiftCop.isGuilty(textField2))
		
		if let suspect = swiftCop.isGuilty(textField2) {
			XCTAssertEqual(suspect.view, textField2)
			XCTAssertEqual(suspect.sentence, "Invalid Email")
		}
	}
	
}
