//
//  OperationSet.swift
//  mitty
//
//  Created by gridscale on 2017/03/05.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

/*
 A model of operatable control set
 */
open class OperationSet :NSObject, Selectable, Operatable {
    
    var controls = Set<Control1>()
    
    static var empty = {
        return OperationSet()
    }
    
    //
    subscript (_ named: String)-> OperationSet {
        return select() {
            $0.name == named
        }
    }
    
    @nonobjc
    func select(_ selector: (Control1) -> Bool) -> OperationSet {
        var set = OperationSet.empty()
        
        for c in controls {
            if type(of: c) is Container1.Type {
                let result = (c as! Container1).select(selector)
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
    static func += (left: inout OperationSet, right: Control1) {
        left.controls.insert(right)
    }
    
    
    /*
     Make it conform to Operatable protocol
     registration Layout coder
     */
    func layout(_ coder: @escaping LayoutCoder) -> Self {
        
        for c in controls {
            c.layout(coder)
        }
        return self
    }
    
    /*
     Make it conform to Operatable protocol
     call operation future in background thread
     */
    func future(_ operation: @escaping (Operatable) -> Void, _ completion: (()->Void)?) -> Self {
        
        
        return self
    }
    
    /*
     Make it conform to Operatable protocol
     register event handler here
     */
    func event(_ id: FormEvent, _ handler: @escaping EventHandler) -> Self {
        for c in controls {
            c.event(id, handler)
        }
        return self
    }
}
