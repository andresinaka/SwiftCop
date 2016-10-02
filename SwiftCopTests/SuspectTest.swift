//
//  SuspectTest.swift
//  SwiftCop
//
//  Created by Andres on 10/27/15.
//  Copyright © 2015 Andres Canal. All rights reserved.
//

import XCTest
@testable import SwiftCop

class SuspectTest: XCTestCase {
	
	var dummyTextField: UITextField!
	
	override func setUp() {
		super.setUp()
		
		self.dummyTextField = UITextField()
		self.dummyTextField.text = "Sample Text"
	}
	
    func testCreateSuspectWithBlockTrue() {
		
		let trial: (_ evidence: String) -> Bool = {
			(evidence: String) -> Bool in
			return true
		}
	
		let suspect = Suspect(view: self.dummyTextField, sentence: "True Trial", trial: trial)
		
		XCTAssertEqual(suspect.verdict(), "")
		XCTAssertEqual(suspect.sentence, "True Trial")
		XCTAssertEqual(suspect.view, self.dummyTextField)
		XCTAssertFalse(suspect.isGuilty())
    }

	func testCreateSuspectWithBlockFalse() {
		
		let trial: (_ evidence: String) -> Bool = {
			(evidence: String) -> Bool in
			return false
		}
		
		let suspect = Suspect(view: self.dummyTextField, sentence: "False Trial", trial: trial)
		
		XCTAssertEqual(suspect.verdict(), "False Trial")
		XCTAssertEqual(suspect.view, self.dummyTextField)
		XCTAssertTrue(suspect.isGuilty())
	}

	func testVeredictReturn() {
		let notGuiltySuspect = Suspect(view: self.dummyTextField, sentence: "True Trial", trial: Trial.beTrue)
		let guiltySuspect = Suspect(view: self.dummyTextField, sentence: "False Trial", trial: Trial.beFalse)
		
		XCTAssertEqual(notGuiltySuspect.verdict(), "")
		XCTAssertEqual(guiltySuspect.verdict(), "False Trial")
	}
	
	func testCreateSuspectWithTrialTrue() {

		let suspect = Suspect(view: self.dummyTextField, sentence: "True Trial", trial: Trial.beTrue)
		
		
		XCTAssertEqual(suspect.verdict(), "")
		XCTAssertEqual(suspect.sentence, "True Trial")
		XCTAssertEqual(suspect.view, self.dummyTextField)
		XCTAssertFalse(suspect.isGuilty())
	}
	
	func testCreateSuspectWithTrialFalse() {
		
		let suspect = Suspect(view: self.dummyTextField, sentence: "False Trial", trial: Trial.beFalse)
		
		XCTAssertEqual(suspect.verdict(), "False Trial")
		XCTAssertEqual(suspect.sentence, "False Trial")
		XCTAssertEqual(suspect.view, self.dummyTextField)
		XCTAssertTrue(suspect.isGuilty())
	}
}
