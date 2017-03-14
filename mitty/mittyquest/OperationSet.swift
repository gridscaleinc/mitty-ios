//
//  OperationSet.swift
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

/*
 A model of operatable control set
 */
open class OperationSet :NSObject, Selectable {
   
    var controls = Set<Control>()
    
    internal override init() {
        super.init()
    }
    
    static var empty = {
        return OperationSet()
    }
    
    @nonobjc
    func select(_ selector: ControlSelector) -> OperationSet {
        var set = OperationSet.empty()
        
        for c in controls {
            if type(of: c) is Container.Type {
                let result = (c as! Container).select(selector)
                set += result
            }
        }
        return set
    }
    
    //
    func union (_ left: OperationSet, _ right: OperationSet) -> OperationSet {
        let set = OperationSet.empty()
        set.controls = (left.controls.union(right.controls))
        return set
    }
    
    static func + (left: inout OperationSet, right: OperationSet) -> OperationSet {
        return left.union(left, right)
    }
    
    static func += (left: inout OperationSet, right: OperationSet) {
        left.controls = left.union(left, right).controls
    }
    
    //
    //
    //
    static func += (left: inout OperationSet, right: Control) {
        left.controls.insert(right)
    }
    
}
