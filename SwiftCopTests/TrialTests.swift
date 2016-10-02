//
//  TrialSwiftCopTests.swift
//  SwiftCop
//
//  Created by Andres on 10/21/15.
//  Copyright © 2015 Andres Canal. All rights reserved.
//

import XCTest
@testable import SwiftCop

class TrialTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
    }

    func testExclusion() {
		let exclusionTrial = Trial.exclusion([".com",".ar", ".uy"])
		let trial = exclusionTrial.trial()

		XCTAssertFalse(trial("http://www.nytimes.com"))
		XCTAssertFalse(trial("http://www.lanacion.com.ar"))
		XCTAssertTrue(trial("http://www.elpais.es"))
	}
	
	func testFormat() {
		let formatTrial = Trial.format("^#([a-f0-9]{6}|[a-f0-9]{3})$") // hexa number with #
		let trial = formatTrial.trial()
		
		XCTAssertTrue(trial("#57b5b5"))
		XCTAssertFalse(trial("57b5b5"))
		XCTAssertFalse(trial("#h7b5b5"))
	}
	
	
	func testInclusion() {
		let inclusionTrial = Trial.inclusion([".com",".ar", ".uy"])
		let trial = inclusionTrial.trial()
		
		XCTAssertTrue(trial("http://www.nytimes.com"))
		XCTAssertTrue(trial("http://www.lanacion.com.ar"))
		XCTAssertFalse(trial("http://www.elpais.es"))
	}
	
	func testEmail() {
		let emailTrial = Trial.email
		let trial = emailTrial.trial()
		
		XCTAssertTrue(trial("test@test.com"))
		XCTAssertFalse(trial("test@test"))
		XCTAssertFalse(trial("test@"))
		XCTAssertFalse(trial("test.com"))
		XCTAssertFalse(trial(".com"))
	}
	
	func testLengthIs() {
		let lengthTrial = Trial.length(.is, 10)
		let trial = lengthTrial.trial()
		
		XCTAssertTrue(trial("0123456789"))
		XCTAssertFalse(trial("56789"))
	}
	
	func testLengthMinimum() {
		let lengthTrial = Trial.length(.minimum, 10)
		let trial = lengthTrial.trial()
		
		XCTAssertTrue(trial("0123456789"))
		XCTAssertFalse(trial("56789"))
	}
	
	func testLengthMaximum() {
		let lengthTrial = Trial.length(.maximum, 10)
		let trial = lengthTrial.trial()
		
		XCTAssertTrue(trial("0123456789"))
		XCTAssertFalse(trial("01234567890"))
	}
	
	func testLengthIntervalsHalfOpen() {
		let interval = Trial.length(.in, 2..<5 as Range)
		let trial = interval.trial()
		
		XCTAssertTrue(trial("1234"))
		XCTAssertFalse(trial("12345"))
		XCTAssertFalse(trial("1"))
	}

	func testLengthIntervalsClosed() {
		let interval = Trial.length(.in, 2...5 as ClosedRange)
		let trial = interval.trial()

		XCTAssertFalse(trial("123456"))
		XCTAssertTrue(trial("12345"))
		XCTAssertTrue(trial("1234"))
		XCTAssertTrue(trial("12"))
		XCTAssertFalse(trial("1"))
	}

	func testInvalid() {
		let interval = Trial.length(.in, 5)
		let trial = interval.trial()
		
		XCTAssertFalse(trial("123456"))
	}
}
