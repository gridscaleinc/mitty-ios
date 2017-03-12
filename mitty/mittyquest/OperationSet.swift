//
//  OperationSet.swift
//  mitty
//
//  Created by gridscale on 2017/03/05.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

/*
 A model of operatable control set
 */
open class OperationSet :NSObject, Selectable, Operatable {
   
    
    var controls = Set<Control>()
    
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
    func event(_ event: UIControlEvents, _ handler: @escaping EventHandler) -> Self {
        for c in controls {
            c.event(event, handler)
        }
        return self
    }
}
