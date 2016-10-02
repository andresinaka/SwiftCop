//
//  ViewController.swift
//  SwiftCop
//
//  Created by Andres on 10/16/15.
//  Copyright © 2015 Andres Canal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var validationLabel: UILabel!
	
	@IBOutlet weak var fullNameMessage: UILabel!
	@IBOutlet weak var emailMessage: UILabel!
	@IBOutlet weak var passwordMessage: UILabel!

	@IBOutlet weak var fullName: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var password: UITextField!
	
	let swiftCop = SwiftCop()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		swiftCop.addSuspect(Suspect(view: self.fullName, sentence: "More Than Two Words Needed"){
			return $0.components(separatedBy: " ").filter{$0 != ""}.count >= 2
		})
		swiftCop.addSuspect(Suspect(view:self.emailTextField, sentence: "Invalid email", trial: Trial.email))
		swiftCop.addSuspect(Suspect(view:self.password, sentence: "Minimum 4 Characters", trial: Trial.length(.minimum, 4)))
	}

	@IBAction func validateFullName(_ sender: UITextField) {
		self.fullNameMessage.text = swiftCop.isGuilty(sender)?.verdict()
	}

	@IBAction func validateEmail(_ sender: UITextField) {
		self.emailMessage.text = swiftCop.isGuilty(sender)?.verdict()
	}
	
	@IBAction func validatePassword(_ sender: UITextField) {
		self.passwordMessage.text = swiftCop.isGuilty(sender)?.verdict()
	}

	@IBAction func allValid(_ sender: UITextField) {
		let nonGultiesMessage = "Everything fine!"
		let allGuiltiesMessage = swiftCop.allGuilties().map{ return $0.sentence}.joined(separator: "\n")
		
		self.validationLabel.text = allGuiltiesMessage.characters.count > 0 ? allGuiltiesMessage : nonGultiesMessage
	}
	
	@IBAction func hideKeyboard(_ sender: AnyObject) {
		self.view.endEditing(true)
	}
}

