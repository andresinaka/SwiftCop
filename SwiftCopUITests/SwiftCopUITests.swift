//
//  SwiftCopUITests.swift
//  SwiftCopUITests
//
//  Created by Andres on 10/16/15.
//  Copyright © 2015 Andres Canal. All rights reserved.
//

import XCTest

class SwiftCopUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFullName() {
		let fullNameTextField = XCUIApplication().textFields["Full Name"]
		fullNameTextField.tap()
		fullNameTextField.typeText("first")
		XCTAssert(XCUIApplication().staticTexts["More Than Two Words Needed"].exists)
		fullNameTextField.typeText(" last")
		XCTAssertFalse(XCUIApplication().staticTexts["More Than Two Words Needed"].exists)
    }
	
	func testEmail() {
		let emailTextField = XCUIApplication().textFields["Email"]
		emailTextField.tap()
		emailTextField.typeText("email")
		XCTAssert(XCUIApplication().staticTexts["Invalid email"].exists)
		emailTextField.typeText("@email.com")
		XCTAssertFalse(XCUIApplication().staticTexts["Invalid Email"].exists)
	}

	func testPassword() {
		let passwordTextField = XCUIApplication().textFields["Password"]
		passwordTextField.tap()
		passwordTextField.typeText("1")
		XCTAssert(XCUIApplication().staticTexts["Minimum 4 Characters"].exists)
		passwordTextField.typeText("234")
		XCTAssertFalse(XCUIApplication().staticTexts["Minimum 4 Characters"].exists)
	}
	
	func testAllValidationsPass(){
		
		let fullNameTextField = XCUIApplication().textFields["Full Name"]
		fullNameTextField.tap()
		fullNameTextField.typeText("fist name")
		
		let emailTextField = XCUIApplication().textFields["Email"]
		emailTextField.tap()
		emailTextField.typeText("email@email.com")
		
		let passwordTextField = XCUIApplication().textFields["Password"]
		passwordTextField.tap()
		passwordTextField.typeText("password")
		
		let policemanElement = XCUIApplication().otherElements.containing(.image, identifier:"policeman").element
		policemanElement.tap()
		
		let checkValidationsButton = XCUIApplication().buttons["Check Validations"]
		checkValidationsButton.tap()

		XCTAssert(XCUIApplication().staticTexts["Everything fine!"].exists)
	}
	
	func testAllValidationsFail(){
		let checkValidationsButton = XCUIApplication().buttons["Check Validations"]
		checkValidationsButton.tap()
		
		XCTAssertFalse(XCUIApplication().staticTexts["Everything fine!"].exists)
	}

}
