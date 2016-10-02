//
//  Trial.swift
//  SwiftCop
//
//  Created by Andres on 10/27/15.
//  Copyright © 2015 Andres Canal. All rights reserved.
//

import UIKit

public protocol TrialProtocol {
	func trial() -> ((_ evidence: String) -> Bool)
}

public enum Lenght {
	case `is`
	case maximum
	case minimum
	case `in`
}

public enum Trial: TrialProtocol {
	case exclusion([String])
	case format(String)
	case inclusion([String])
	case email
	case length(Lenght,Any)
	case beTrue
	case beFalse
	
	public func trial() -> ((_ evidence: String) -> Bool){
		switch self {
		case let .exclusion(exclusionElements):
			return { (evidence: String) -> Bool in
				
				for exclusionElement in exclusionElements {
					if ((evidence.range(of: exclusionElement)) != nil) {
						return false
					}
				}
				return true
			}
			
		case let .format(regex):
			return { (evidence: String) -> Bool in
				let regexTest = NSPredicate(format:"SELF MATCHES %@", regex)
				return regexTest.evaluate(with: evidence)
			}
			
		case let .inclusion(inclusionElements):
			return { (evidence: String) -> Bool in
				
				for inclusionElement in inclusionElements {
					if ((evidence.range(of: inclusionElement)) != nil) {
						return true
					}
				}
				return false
			}
			
		case .email:
			return { (evidence: String) -> Bool in
				let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
				let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
				return emailTest.evaluate(with: evidence)
			}
			
		case .length(Lenght.is, let exact as Int):
			return { (evidence: String) -> Bool in
				return evidence.characters.count == exact
			}
			
		case .length(Lenght.minimum, let minimum as Int):
			return { (evidence: String) -> Bool in
				return evidence.characters.count >= minimum
			}
			
		case .length(Lenght.maximum , let maximum as Int):
			return { (evidence: String) -> Bool in
				return evidence.characters.count <= maximum
			}
			
		case .length(Lenght.in , let interval as Range<Int>):
			return { (evidence: String) -> Bool in
				return interval.contains(evidence.characters.count)
			}
			
		case .length(Lenght.in , let interval as ClosedRange<Int>):
			return { (evidence: String) -> Bool in
				return interval.contains(evidence.characters.count)
			}
			
		case .beTrue:
			return { (evidence: String) -> Bool in
				return true
			}

		case .beFalse:
			return { (evidence: String) -> Bool in
				return false
			}

		default:
			return { (evidence: String) -> Bool in
				return false
			}
		}
	}
}
