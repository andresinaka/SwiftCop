//
//  Suspectable.swift
//  SwiftCop
//
//  Created by Hiroaki Muronaka on 2016/10/28.
//  Copyright © 2016年 Andres Canal. All rights reserved.
//

import UIKit

public protocol Suspectable:Equatable {
    var suspectText:String { get }
    var isSupportSuspectable:Bool { get }
}

extension UIView: Suspectable {
    
    open var suspectText:String {
        return ""
    }
    
    open var isSupportSuspectable:Bool {
        return false
    }
    
}

extension UITextField {
    open override var suspectText:String {
        return text!
    }
    
    open override var isSupportSuspectable:Bool {
        return true
    }
}

extension UITextView {
    open override var suspectText:String {
        return text
    }
    
    open override var isSupportSuspectable:Bool {
        return true
    }
}

