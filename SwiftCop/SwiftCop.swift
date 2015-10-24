//
//  SwiftCop.swift
//  SwiftCop
//
//  Created by Andres on 10/16/15.
//  Copyright © 2015 Andres Canal. All rights reserved.
//

import Foundation
import UIKit


public enum Lenght {
	case Is
	case Maximum
	case Minimum
}


public enum Trial {
	case Exclusion([String])
	case Format(String)
	case Inclusion([String])
	case Email
	case Length(Lenght,Int)
	
	public func trial() -> ((evidence: String) -> Bool){
		switch self {
		case let .Exclusion(exclusionElements):
			return { (evidence: String) -> Bool in
				
				for exclusionElement in exclusionElements {
					if ((evidence.rangeOfString(exclusionElement)) != nil) {
						return false
					}
				}
				return true
			}
			
		case let .Format(regex):
			return { (evidence: String) -> Bool in
				let regexTest = NSPredicate(format:"SELF MATCHES %@", regex)
				return regexTest.evaluateWithObject(evidence)
			}
			
		case let .Inclusion(inclusionElements):
			return { (evidence: String) -> Bool in
				
				for inclusionElement in inclusionElements {
					if ((evidence.rangeOfString(inclusionElement)) != nil) {
						return true
					}
				}
				return false
			}
			
		case .Email:
			return { (evidence: String) -> Bool in
				let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
				let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
				return emailTest.evaluateWithObject(evidence)
			}
		
		case .Length(Lenght.Is, let exact):
			return { (evidence: String) -> Bool in
				return evidence.characters.count == exact
			}
			
		case .Length(Lenght.Minimum, let minimum):
			return { (evidence: String) -> Bool in
				return evidence.characters.count >= minimum
			}
			
		case .Length(Lenght.Maximum , let maximum):
			return { (evidence: String) -> Bool in
				return evidence.characters.count <= maximum
			}
		}
	}
}

public struct Suspect {
	var view: UITextField
	var trial: (evidence: String) -> Bool
	var sentence: String
	
	public init(view: UITextField, sentence: String, trial: (evidence: String) -> Bool) {
		self.view = view
		self.trial = trial
		self.sentence = sentence
	}
	
	public init(view: UITextField, sentence: String, trial: Trial) {
		self.view = view
		self.trial = trial.trial()
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