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

	@IBOutlet weak var fullName: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var password: UITextField!
	
	let swiftCop = SwiftCop()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		swiftCop.addSuspect(Suspect(view: self.fullName, sentence: "More Than Two Words Needed"){
			return $0.componentsSeparatedByString(" ").filter{$0 != ""}.count >= 2
		})
		swiftCop.addSuspect(Suspect(view:self.emailTextField, sentence: "Invalid email", trial: Trial.Email))
		swiftCop.addSuspect(Suspect(view:self.password, sentence: "Minimum 4 Characters ", trial: Trial.Length(.Minimum, 4)))
	}
	
	@IBAction func validate(sender: UITextField) {
		if let suspect = swiftCop.isGuilty(sender) {
			self.validationLabel.text = suspect.sentence
		} else {
			self.validationLabel.text = ""
		}
	}

	@IBAction func allValid(sender: AnyObject) {
		var message = "Everything fine!"
		if(swiftCop.anyGuilty()){
			message = "Someone is guilty!"
		}
		
		let alertController = UIAlertController(title: "", message: message, preferredStyle: .Alert)
		alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))

		self.presentViewController(alertController, animated: true, completion: nil)
	}
}

