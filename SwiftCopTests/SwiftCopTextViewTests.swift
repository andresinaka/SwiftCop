//
//  SwiftCopTextViewTests.swift
//  SwiftCop
//
//  Created by 室中 洋陽 on 2016/10/28.
//  Copyright © 2016年 Andres Canal. All rights reserved.
//

import XCTest
@testable import SwiftCop

class SwiftCopTextViewTests: XCTestCase {
    
    var nameTextView: UITextView!
    var emailTextView: UITextView!
    
    
    override func setUp() {
        super.setUp()
        
        self.nameTextView = UITextView()
        self.nameTextView.text = "Not Used"
        
        self.emailTextView = UITextView()
        self.emailTextView.text = "Not Used"
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddSuspect() {
        let swiftCop = SwiftCop()
        swiftCop.addSuspect(Suspect(view: self.nameTextView, sentence: "True Trial", trial: Trial.beTrue))
        swiftCop.addSuspect(Suspect(view: self.nameTextView, sentence: "False Trial", trial: Trial.beFalse))
        XCTAssertTrue(swiftCop.suspects.count == 2)
    }
    
    func testAnyGuiltyFalse() {
        let swiftCop = SwiftCop()
        swiftCop.addSuspect(Suspect(view: self.nameTextView, sentence: "True Trial", trial: Trial.beTrue))
        XCTAssertFalse(swiftCop.anyGuilty())
    }
    
    func testAnyGuiltyTrue() {
        let swiftCop = SwiftCop()
        swiftCop.addSuspect(Suspect(view: self.nameTextView, sentence: "False Trial", trial: Trial.beFalse))
        XCTAssertTrue(swiftCop.anyGuilty())
    }
    
    func testIsGuiltyTrue() {
        let swiftCop = SwiftCop()
        
        let textFieldNotGuilty = UITextView()
        textFieldNotGuilty.text = "Not guilty"
        
        let textFieldGuilty = UITextView()
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
        swiftCop.addSuspect(Suspect(view: self.nameTextView, sentence: "Not Guilty") {
            (evidence: String) -> Bool in
            return true
        })
        
        swiftCop.addSuspect(Suspect(view: self.nameTextView, sentence: "Not Guilty") {
            (evidence: String) -> Bool in
            return true
        })
        
        XCTAssertFalse(swiftCop.anyGuilty())
    }
    
    func testCustomTrialGuilty() {
        let swiftCop = SwiftCop()
        swiftCop.addSuspect(Suspect(view: self.nameTextView, sentence: "Guilty") {
            (evidence: String) -> Bool in
            return false
        })
        
        swiftCop.addSuspect(Suspect(view: self.nameTextView, sentence: "Not Guilty") {
            (evidence: String) -> Bool in
            return true
        })
        
        XCTAssertTrue(swiftCop.anyGuilty())
    }
    
    func testCustomTrialAllGuiltiesFalse() {
        let swiftCop = SwiftCop()
        swiftCop.addSuspect(Suspect(view: self.nameTextView, sentence: "Not Guilty", trial: Trial.beTrue))
        swiftCop.addSuspect(Suspect(view: self.nameTextView, sentence: "Not Guilty", trial: Trial.beTrue))
        
        let guilties = swiftCop.allGuilties()
        XCTAssertTrue(guilties.count == 0)
    }
    
    func testCustomTrialAllGuiltiesTrue() {
        let swiftCop = SwiftCop()
        swiftCop.addSuspect(Suspect(view: self.nameTextView, sentence: "Guilty", trial: Trial.beFalse))
        swiftCop.addSuspect(Suspect(view: self.nameTextView, sentence: "Not Guilty", trial: Trial.beTrue))
        
        let guilties = swiftCop.allGuilties()
        XCTAssertTrue(guilties.count == 1)
        XCTAssertEqual(guilties.first!.view, self.nameTextView)
        XCTAssertEqual(guilties.first!.verdict(), "Guilty")
    }
    
    func testNoTextTextView() {
        let swiftCop = SwiftCop()
        self.nameTextView.text = nil
        swiftCop.addSuspect(Suspect(view: self.nameTextView, sentence: "Guilty" , trial: Trial.beFalse))
        
        let guilties = swiftCop.allGuilties()
        XCTAssertTrue(guilties.count == 1)
    }
}
