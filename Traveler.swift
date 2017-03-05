//
//  Traveler.swift
//  mitty
//
//  Created by gridscale on 2017/03/05.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

var Tagnizer : () -> Int = ViewTagnizer.tagNizer.initTagnizer()


class ViewTagnizer {
    static var tagNizer = ViewTagnizer()
    
    let lock = NSLock()
    var initialized = false
    var tagNizer : (() -> Int)? = nil
    
    func initTagnizer () -> () -> Int {
//        lock.lock()
//        defer {lock.unlock()}
        if initialized {
            return tagNizer!
        }
        var currentTag : Int = 1000000000
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

