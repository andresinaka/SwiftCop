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
	case In
}


public enum Trial {
	case Exclusion([String])
	case Format(String)
	case Inclusion([String])
	case Email
	case Length(Lenght,Any)
	
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
		
		case .Length(Lenght.Is, let exact as Int):
			return { (evidence: String) -> Bool in
				return evidence.characters.count == exact
			}
			
		case .Length(Lenght.Minimum, let minimum as Int):
			return { (evidence: String) -> Bool in
				return evidence.characters.count >= minimum
			}
			
		case .Length(Lenght.Maximum , let maximum as Int):
			return { (evidence: String) -> Bool in
				return evidence.characters.count <= maximum
			}
			
		case .Length(Lenght.In , let interval as HalfOpenInterval<Int>):
			return { (evidence: String) -> Bool in
				return interval.contains(evidence.characters.count)
			}
			
		case .Length(Lenght.In , let interval as ClosedInterval<Int>):
			return { (evidence: String) -> Bool in
				return interval.contains(evidence.characters.count)
			}

		default:
			return { (evidence: String) -> Bool in
				return false
			}
		}
	}
}

public struct Suspect {
	private(set) public var view: UITextField
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
	
	public func isGuilty() -> Bool {
		return !self.trial(evidence: self.view.text!)
	}
}

public class SwiftCop {
	var suspects = Array<Suspect>()
	
	public func addSuspect(suspect: Suspect) {
		suspects.append(suspect)
	}
	
	public func anyGuilty() -> Bool {
		return suspects.filter{
			return $0.isGuilty()
		}.count != 0
	}
	
	public func allGuilties() -> Array<Suspect> {
		return suspects.filter{
			return $0.isGuilty()
		}
	}
	
	public func isGuilty(textView: UITextField) -> Suspect? {
		for suspect in suspects where suspect.view == textView {
			if suspect.isGuilty() {
				return suspect
			}
		}
		return nil
	}
}