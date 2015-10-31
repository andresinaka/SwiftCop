//
//  Suspect.swift
//  SwiftCop
//
//  Created by Andres on 10/27/15.
//  Copyright © 2015 Andres Canal. All rights reserved.
//

import UIKit

public struct Suspect {
	private(set) public var view: UITextField
	private var trial: (evidence: String) -> Bool
	private(set) public var sentence: String
	
	public init(view: UITextField, sentence: String, trial: (evidence: String) -> Bool) {
		self.view = view
		self.trial = trial
		self.sentence = sentence
	}
	
	public init(view: UITextField, sentence: String, trial: TrialProtocol) {
		self.view = view
		self.trial = trial.trial()
		self.sentence = sentence
	}
	
	public func isGuilty() -> Bool {
		return !self.trial(evidence: self.view.text!)
	}
	
	public func verdict() -> String {
		return self.isGuilty() ? self.sentence : ""
	}
}