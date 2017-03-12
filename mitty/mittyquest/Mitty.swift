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

    open subscript(_ selector: String) -> Mitty {
        let isTarget = compile(selector)
        let m = Mitty()
        for c in controls {
            if (isTarget(c)) {
                m.controls.insert(c)
            }
        }
        return self
    }
    
    // define a protocol that can
    func forEach (_ selector: ControlSelector, _ operation: (_ selected: Control) -> Void) -> Mitty {
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
    @discardableResult
    func bindEvent (for event: UIControlEvents, _ handler: @escaping EventHandler ) -> Mitty {
        for c in controls {
            c.event(event, handler)
        }
        return self
        
    }
    
    // Special for button
    func button(_ selector: ControlSelector, onTap: @escaping EventHandler) -> Mitty {
        
        let m = Mitty()
        for c in controls {
            if (!(isButton(c))) {
                continue
            }
            if (selector(c)) {
                c.event(.touchUpInside, onTap)
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
                c.event(.editingDidBegin, onFocus)
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
    
    private func isButton(_ c: Control) -> Bool {
        return type(of: c._view) is UIButton.Type
    }
    
    private func isTextField(_ c: Control) -> Bool {
        return type(of: c._view) is UITextField.Type
    }

}

extension Mitty {
    func compile(_ selection: String) -> ControlSelector {
        var pattern = selection.trimmingCharacters(in: NSCharacterSet.whitespaces)
        func f ( _ control : Control) -> Bool {
            
            if (pattern == "") {
                return true
            }
            
            let m = Matching(pattern)
            return m.matches(control)
        }
        
        return f
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

public func mitty(_ section: Section) -> Mitty {
    let mitty = Mitty()
    var opSet = mitty as OperationSet
    opSet += section.selectAll()
    return mitty
}

public func mitty(_ row: Row) -> Mitty {
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
    let c = Control(view:view)
    let m = Mitty()
    m.controls.insert(c)
    return m
}
