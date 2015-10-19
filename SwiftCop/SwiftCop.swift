//
//  SwiftCop.swift
//  SwiftCop
//
//  Created by Andres on 10/16/15.
//  Copyright © 2015 Andres Canal. All rights reserved.
//

import Foundation
import UIKit

public struct Suspect {
	var view: UITextField
	var trial: (evidence: String) -> Bool
	var sentence: String
	
	public init(view: UITextField, sentence: String, trial: (evidence: String) -> Bool) {
		self.view = view
		self.trial = trial
		self.sentence = sentence
	}
}

public class SwiftCop {
	var suspects = Array<Suspect>()
	
	public func addSuspect(suspect: Suspect) {
		suspects.append(suspect)
	}
	
	public func anyGuilty() -> Bool {
		return suspects.filter{
			if let text = $0.view.text {
				return !$0.trial(evidence: text)
			}
			return true
		}.count != 0
	}
	
	public func allGuilties() -> Array<Suspect> {
		return suspects.filter{
			if let text = $0.view.text {
				return !$0.trial(evidence: text)
			}
			return false
		}
	}
}