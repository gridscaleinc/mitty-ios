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
    func bind (_ selector: ControlSelector, _ event: FormEvent, _ handler: @escaping EventHandler ) -> Mitty {
        let m = Mitty()
        for c in controls {
            if (selector(c)) {
                c.event(event, handler)
                m.controls.insert(c)
            }
        }
        return m
        
    }
    
    // Special for button
    func button(_ selector: ControlSelector, onTap: @escaping EventHandler) -> Mitty {
        
        let m = Mitty()
        for c in controls {
            if (!(isButton(c))) {
                continue
            }
            if (selector(c)) {
                c.event(FormEvent.onTap, onTap)
                m.controls.insert(c)
            }
        }
        return m
    }
    
    // Special for button
    func textField(_ selector: ControlSelector, onFocus: @escaping EventHandler) -> Mitty {
        let m = Mitty()
        for c in controls {
            if (!(isTextField(c))) {
                continue
            }
            if (selector(c)) {
                c.event(FormEvent.onFocus, onFocus)
                m.controls.insert(c)
            }
        }
        
        return m
    }
    
    // Special for button
    func textField(_ selector: ControlSelector, validator: Validator) -> Mitty {
        let m = Mitty()
        for c in controls {
            if (!isTextField(c)) {
                continue
            }
            if (selector(c)) {
                validator(c)
                m.controls.insert(c)
            }
        }
        return m
    }
    
    //
    func animate(_ selector: ControlSelector, animator: () -> Void, duration: Int) -> Mitty {
        return self
    }
    
    // enable
    // disable
    // hide
    // remove
    
    func ifThen(_ selector: ControlSelector, ifTrue: Conditionor, thenDo: ControlOperation) -> Mitty {
        let m = Mitty()
        for c in controls {
            if (selector(c)) {
                if (ifTrue(c)) {
                    thenDo(c)
                }
                m.controls.insert(c)
            }
        }
        return m
    }
    
    private func isButton(_ c: Control1) -> Bool {
        return type(of: c._view) is UIButton.Type
    }
    
    private func isTextField(_ c: Control1) -> Bool {
        return type(of: c._view) is UITextField.Type
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

public func mitty(_ view: UIView) -> Mitty {
    return ViewTraveler().travel(view)
}
