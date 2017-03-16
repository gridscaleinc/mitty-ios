//
//  Abstracts.swift
//
//  MittyQuest
//
//
//  Created by gridscale on 2017/03/04.
//  Copyright © 2017 GridScale Inc. All rights reserved.
//
//  This code is distributed under the terms and conditions of the MIT license.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

import Foundation
import UIKit

// Protocol of object that Operateable
// by layout, event registeration, and Async excution
protocol Operatable {
    func layout(_ coder: @escaping LayoutCoder) -> Self
    func event(_ event: UIControlEvents, _ handler: @escaping EventHandler) -> Self
    func future(_ operation: @escaping (Operatable) -> Void, _ completion: (()->Void)?) -> Self
}

// Functions, Closures or Method that conform to select controls
typealias ControlSelector = (Control) -> Bool

// name, tag, path
protocol Selectable {
    func select(_ selector: ControlSelector ) -> OperationSet
}


// For any Event handling blocks
typealias  EventHandler = (_ view: UIView) -> Void

// For block that to change the View Layut
typealias LayoutCoder = (_ c: Control) ->Void

// For block that validate inputed value of textfield etc.
typealias Validator = (_ c: Control ) -> Void

//
typealias Conditionor = (_ c: Control ) -> Bool

typealias ControlOperation = (_ c: Control ) -> Void

struct Stack<E> {
    var values : [E] = []
    
    mutating func push(_ e : E) {
        values.append(e)
    }
    
    mutating func pop() -> E? {
        return values.removeLast()
    }
    
    func peek() -> E? {
        return values.last
    }
    
    //
    var isEmpty : Bool {
        return values.isEmpty
    }
}

// MARK: Operators

precedencegroup FormPrecedence {
    associativity: left
    higherThan: LogicalConjunctionPrecedence
}

precedencegroup SectionPrecedence {
    associativity: left
    higherThan: FormPrecedence
}

infix operator +++ : FormPrecedence
infix operator <<< : SectionPrecedence
prefix operator +=

