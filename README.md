![SwiftCop](swiftCop.png)

# SwiftCop
```
Swift 3.0 Support on master branch! 👌👌 
Swift 2.3 Support on Swift2.3.
```

SwiftCop is a validation library fully written in Swift and inspired by the clarity of [Ruby On Rails Active Record validations](http://guides.rubyonrails.org/active_record_validations.html).

[![Build Status](https://travis-ci.org/andresinaka/SwiftCop.svg)](https://travis-ci.org/andresinaka/SwiftCop) [![codecov.io](https://codecov.io/github/andresinaka/SwiftCop/badge.svg?branch=master)](https://codecov.io/github/andresinaka/SwiftCop?branch=master) [![codecov.io](https://img.shields.io/badge/pod-v1.0.0-brightgreen.svg)]()

### Objective

Build a standard drop-in library for validations in Swift while making it easily extensible for users to create custom validations. And avoid developers from writing over and over again the same code and validations for different projects.

## Features

- Quick validations.
- Super simple and declarative syntax.
- Easily extensible.
- Fully Swift 2.0

## Modules

SwiftCop was built around three different concepts:

### Trial

```Trial``` is an ```Enum``` that implements the ```TrialProtocol```

```swift
public protocol TrialProtocol {
	func trial() -> ((_ evidence: String) -> Bool)
}
```

We can use ```Trial``` to quickly validate ```strings```. ```SwiftCop``` ships with a very fully featured ```Trial``` implementation. The following trials are provided:

#### ```Exclusion([String])```
This validates that the attributes are not included in the evidence string.

```swift
let exclusionTrial = Trial.exclusion([".com",".ar", ".uy"])
let trial = exclusionTrial.trial()

XCTAssertFalse(trial("http://www.nytimes.com"))
XCTAssertFalse(trial("http://www.lanacion.com.ar"))
XCTAssertTrue(trial("http://www.elpais.es"))
```

#### ```Format(String)```
This validates whether the evidence matches a given regular expression.

```swift
let formatTrial = Trial.format("^#([a-f0-9]{6}|[a-f0-9]{3})$") // hexa number with #
let trial = formatTrial.trial()
	
XCTAssertTrue(trial("#57b5b5"))
XCTAssertFalse(trial("57b5b5"))
XCTAssertFalse(trial("#h7b5b5"))
```

#### ```Inclusion([String])```
This validates that the attributes are included in the evidence string.

```swift
let inclusionTrial = Trial.inclusion([".com",".ar", ".uy"])
let trial = inclusionTrial.trial()
	
XCTAssertTrue(trial("http://www.nytimes.com"))
XCTAssertTrue(trial("http://www.lanacion.com.ar"))
XCTAssertFalse(trial("http://www.elpais.es"))
```

#### ```Email```
This validates whether the evidence is an email or not.

```swift
let emailTrial = Trial.email
let trial = emailTrial.trial()
XCTAssertTrue(trial("test@test.com"))
```

#### ```Length(Length,Any)```
This validates the length of given evidence:

```swift
let lengthTrial = Trial.Length(.Is, 10)
let trial = lengthTrial.trial()
XCTAssertTrue(trial("0123456789"))
```
```swift
let lengthTrial = Trial.Length(.Minimum, 10)
let trial = lengthTrial.trial()
XCTAssertTrue(trial("0123456789"))
```
```swift
let lengthTrial = Trial.Length(.Maximum, 10)
let trial = lengthTrial.trial()		
XCTAssertTrue(trial("0123456789"))
```
```swift
let interval = Trial.Length(.In, 2..<5 as HalfOpenInterval)
let trial = interval.trial()
XCTAssertTrue(trial("1234"))
```
```swift
let interval = Trial.Length(.In, 2...5 as ClosedInterval)
let trial = interval.trial()
XCTAssertFalse(trial("123456"))
```

### Suspect

The ```Suspect``` is a ```Struct``` that is the glue between some other concepts always used while validating fields. It puts together a ```UITextField``` that is going to be the source of the ```evidence```, a ```sentence``` that is going to be the text shown if the ```suspect``` is guilty (when the ```Trial``` returns false) and the ```Trial``` itself, that can be a custom made trial for the suspect or you can use one of the trials provided by the library:

```swift
Suspect(view: UITextField, sentence: String, trial: TrialProtocol)
Suspect(view: UITextField, sentence: String, trial: (String) -> Bool)
```

We can check if the ```Suspect``` is guilty or not with:

```
func isGuilty() -> Bool
```

This method is going to return ```true``` if the ```Trial``` returns ```false```.

Also we can directly ask for the ```verdict``` on the ```Suspect```, this is going to check if it's guilty or not and then return and empty string (```""```) or the ```sentence```.

For example: 

```swift
let suspect = Suspect(view: self.dummyTextField, sentence: "Invalid email", trial: .Email)		
let verdict = suspect.verdict() // this can be "" or "Invalid Email"
```

### SwiftCop

Finally we have the guy that is going to enforce the validations! The cop is going to get all the suspects together and give us the tools to check who are the guilty suspects or if there is any guilty suspect at all.

As you can imagine this is going to add a suspect under the vigilance of a cop, we can add as many suspects as we want:

```swift
open func addSuspect(_ suspect: Suspect)
```

This let us check if there is any guilty suspect between all the suspects under the surveillance of our cop:

```swift
public func anyGuilty() -> Bool
```

This will let us know all the guilty suspects our cop found:

```swift
public func allGuilties() -> Array<Suspect>
```

This let us check if a UITextField that is suspect is guilty or not:

```swift
public func isGuilty(textField: UITextField) -> Suspect?
```

## Example

The example is shipped in the repository:

```Swift
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
```

![SwiftCopExampel](swiftCopExample.gif)

# Installation

You can just clone the repo and copy the ```SwiftCop``` folder to your project or you can use one of the following options:

### Setting up with [CocoaPods](http://cocoapods.org/)

```
pod 'SwiftCop'
```

Then:

``` 
import SwiftCop
```

And you are all set! 

### Setting up with [Carthage](https://github.com/Carthage/Carthage)

- TODO
