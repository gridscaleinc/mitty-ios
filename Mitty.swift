//
//  Somitty.swift
//  mitty
//
//  Created by gridscale on 2017/03/04.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

//
//
//
open class Mitty : OperationSet {
    
    open func named(_ name: String) -> Control1? {
        return super[name].controls.first
    }
    
    // define a protocol that can
    func forEach (_ selector: ControlSelector, _ operation: (_ selected: Control1) -> Void) -> Mitty {
        let m = Mitty()
        for c in controls {
            if (selector(c)) {
                operation(c)
                m.controls.insert(c)
            }
        }
        return m
    }
    
    // define a function that access all the values in selectable
    func val(_ value: Any) -> AnyObject  {
        return self
    }
    
    // event bind
    func bind (_selector: ControlSelector, _ event: FormEvent, _ handler: EventHandler ) -> Mitty {
        return self
    }
    
    // Special for button
    func button(_ selector: ControlSelector, onTap: EventHandler) -> Mitty {
        return self
    }
    
    // Special for button
    func textField(_ selector: (), onFocus: EventHandler) -> Mitty {
        return self
    }
    
    // Special for button
    func textField(_ selector: ControlSelector, validator: EventHandler) -> Mitty {
        return self
    }
    
    //
    func animate(_ selector: ControlSelector, animator: () -> Void, duration: Int) -> Mitty {
        return self
    }
    
    // enable
    // disable
    // hide
    // remove
    
    func ifThen(_ selector: ControlSelector, _ ifTrue: () -> Bool, _ thenDo: EventHandler) -> Mitty {
        return self
    }

}

public func mitty(_ form: MittyForm) -> Mitty {
    let mitty = Mitty()
    var opSet = mitty as OperationSet
    for s in form.sections {
        opSet += s.selectAll()
    }
    return mitty
}

public func mitty(_ section: Section1) -> Mitty {
    let mitty = Mitty()
    var opSet = mitty as OperationSet
    opSet += section.selectAll()
    return mitty
}

public func mitty(_ row: Row1) -> Mitty {
    let mitty = Mitty()
    var opSet = mitty as OperationSet
    opSet += row.selectAll()
    return mitty
}

public func mitty(_ col: Col) -> Mitty {
    let mitty = Mitty()
    var opSet = mitty as OperationSet
    opSet += col.selectAll()
    return mitty
}
