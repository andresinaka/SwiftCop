//
//  TrialSwiftCopTests.swift
//  SwiftCop
//
//  Created by Andres on 10/21/15.
//  Copyright © 2015 Andres Canal. All rights reserved.
//

import XCTest
@testable import SwiftCop

class TrialSwiftCopTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
    }

    func testExclusion() {
		let exclusionTrial = Trial.Exclusion([".com",".ar", ".uy"])
		let trial = exclusionTrial.trial()
		
		XCTAssertFalse(trial(evidence: "http://www.nytimes.com"))
		XCTAssertFalse(trial(evidence: "http://www.lanacion.com.ar"))
		XCTAssertTrue(trial(evidence: "http://www.elpais.es"))
	}
	
	func testFormat() {
		let formatTrial = Trial.Format("^#([a-f0-9]{6}|[a-f0-9]{3})$") // hexa number with #
		let trial = formatTrial.trial()
		
		XCTAssertTrue(trial(evidence: "#57b5b5"))
		XCTAssertFalse(trial(evidence: "57b5b5"))
		XCTAssertFalse(trial(evidence: "#h7b5b5"))
	}
	
	
	func testInclusion() {
		let inclusionTrial = Trial.Inclusion([".com",".ar", ".uy"])
		let trial = inclusionTrial.trial()
		
		XCTAssertTrue(trial(evidence: "http://www.nytimes.com"))
		XCTAssertTrue(trial(evidence: "http://www.lanacion.com.ar"))
		XCTAssertFalse(trial(evidence: "http://www.elpais.es"))
	}
	
	func testEmail() {
		let emailTrial = Trial.Email
		let trial = emailTrial.trial()
		
		XCTAssertTrue(trial(evidence: "test@test.com"))
		XCTAssertFalse(trial(evidence: "test@test"))
		XCTAssertFalse(trial(evidence: "test@"))
		XCTAssertFalse(trial(evidence: "test.com"))
		XCTAssertFalse(trial(evidence: ".com"))
	}
	
	func testLengthIs() {
		let lengthTrial = Trial.Length(.Is, 10)
		let trial = lengthTrial.trial()
		
		XCTAssertTrue(trial(evidence: "0123456789"))
		XCTAssertFalse(trial(evidence: "56789"))
	}
	
	func testLengthMinimum() {
		let lengthTrial = Trial.Length(.Minimum, 10)
		let trial = lengthTrial.trial()
		
		XCTAssertTrue(trial(evidence: "0123456789"))
		XCTAssertFalse(trial(evidence: "56789"))
	}
	
	func testLengthMaximum() {
		let lengthTrial = Trial.Length(.Maximum, 10)
		let trial = lengthTrial.trial()
		
		XCTAssertTrue(trial(evidence: "0123456789"))
		XCTAssertFalse(trial(evidence: "01234567890"))
	}
	
	func testLengthIntervalsHalfOpen() {
		let interval = Trial.Length(.In, 2..<5 as HalfOpenInterval)
		let trial = interval.trial()
		
		XCTAssertTrue(trial(evidence: "1234"))
		XCTAssertFalse(trial(evidence: "12345"))
		XCTAssertFalse(trial(evidence: "1"))
	}

	func testLengthIntervalsClosed() {
		let interval = Trial.Length(.In, 2...5 as ClosedInterval)
		let trial = interval.trial()

		XCTAssertFalse(trial(evidence: "123456"))
		XCTAssertTrue(trial(evidence: "12345"))
		XCTAssertTrue(trial(evidence: "1234"))
		XCTAssertTrue(trial(evidence: "12"))
		XCTAssertFalse(trial(evidence: "1"))
	}
	
	func testInvalid() {
		let interval = Trial.Length(.In, 5)
		let trial = interval.trial()
		
		XCTAssertFalse(trial(evidence: "123456"))
	}
	
}
