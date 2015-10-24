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
			return $0.componentsSeparatedByString(" ").count >= 2
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
			return $0.componentsSeparatedByString(" ").count >= 2
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
	
	func testTrialValidation() {
		let swiftCop = SwiftCop()
		self.nameTextField.text = "email@email.com"
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "Invalid Email" , trial: Trial.Email))

		let guilties = swiftCop.allGuilties()
		XCTAssertTrue(guilties.count == 0)
		
		self.nameTextField.text = "email@email"
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "Invalid Email" , trial: Trial.Email))
		XCTAssertTrue(guilties.count == 1)
	}
}
