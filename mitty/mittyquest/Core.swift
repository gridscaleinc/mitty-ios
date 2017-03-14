//
//  Core.swift
//  mitty
//
//  Created by gridscale on 2017/03/09.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
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

