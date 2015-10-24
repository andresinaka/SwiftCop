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
}
