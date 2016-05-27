//
//  Trial.swift
//  SwiftCop
//
//  Created by Andres on 10/27/15.
//  Copyright © 2015 Andres Canal. All rights reserved.
//

import UIKit

public protocol TrialProtocol {
	func trial() -> ((evidence: String) -> Bool)
}

public enum Lenght {
	case Is
	case Maximum
	case Minimum
	case In
}

public enum Trial: TrialProtocol {
	case Exclusion([String])
	case Format(String)
	case Inclusion([String])
	case Email
	case Length(Lenght,Any)
	case False
	case True
    case USAPhoneNumber
    
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
				/*let regexTest = NSPredicate(format:"SELF MATCHES %@", regex)
				return regexTest.evaluateWithObject(evidence)*/
                return self.evidenceIsValid(evidence, forRegexFormat: regex)
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
				/*let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
				return emailTest.evaluateWithObject(evidence)*/
                return self.evidenceIsValid(evidence, forRegexFormat: emailRegEx)
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
			
		case .True:
			return { (evidence: String) -> Bool in
				return true
			}

		case .False:
			return { (evidence: String) -> Bool in
				return false
			}
        case .USAPhoneNumber:
            return { (evidence: String) -> Bool in
                let usaPhoneRegex = "((\\(\\d{3}(\\)-|\\)\\s))|\\d{3}(-|\\s)?)\\d{3}-?\\d{4}"
                return self.evidenceIsValid(evidence, forRegexFormat: usaPhoneRegex)
            }

		default:
			return { (evidence: String) -> Bool in
				return false
			}
		}
	}
    
    private func evidenceIsValid(evidence: String, forRegexFormat regex: String) -> Bool {
        let test = NSPredicate(format:"SELF MATCHES %@", regex)
        return test.evaluateWithObject(evidence)
    }
}
