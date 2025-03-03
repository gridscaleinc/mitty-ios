//
//  Tagnizer.swift
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

var Tagnizer : () -> Int = ViewTagnizer.tagNizer.initTagnizer()


class ViewTagnizer {
    static var tagNizer = ViewTagnizer()
    
    let lock = NSLock()
    var initialized = false
    var tagNizer : (() -> Int)? = nil
    
    func initTagnizer () -> () -> Int {
        if initialized {
            return tagNizer!
        }
        var currentTag : Int = 100
        let f = { () -> Int in
            currentTag += 1
            return currentTag
        }
        tagNizer = f
        initialized = true
        return f
    }
    
    func next() -> Int {
        lock.lock()
        defer {lock.unlock()}
        return Tagnizer()
    }
}

public func nextTag () -> Int {
    return ViewTagnizer.tagNizer.next()
}

