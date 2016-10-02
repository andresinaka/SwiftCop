//
//  SwiftCop.swift
//  SwiftCop
//
//  Created by Andres on 10/16/15.
//  Copyright © 2015 Andres Canal. All rights reserved.
//

import Foundation
import UIKit

open class SwiftCop {
	var suspects = Array<Suspect>()
	
	public init(){}
	
	open func addSuspect(_ suspect: Suspect) {
		suspects.append(suspect)
	}
	
	open func anyGuilty() -> Bool {
		return suspects.filter{
			return $0.isGuilty()
		}.count != 0
	}
	
	open func allGuilties() -> Array<Suspect> {
		return suspects.filter{
			return $0.isGuilty()
		}
	}
	
	open func isGuilty(_ textField: UITextField) -> Suspect? {
		for suspect in suspects where suspect.view == textField {
			if suspect.isGuilty() {
				return suspect
			}
		}
		return nil
	}	
}
