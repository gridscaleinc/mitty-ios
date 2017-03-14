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
open class MittyQuest : OperationSet {

    internal override init() {
        super.init()
    }
    
    open subscript(_ selector: String) -> MittyQuest {
        let isTarget = compile(selector)
        let m = MittyQuest()
        for c in controls {
            if (isTarget(c)) {
                m.controls.insert(c)
            }
        }
        return m
    }
    
    @nonobjc
    open subscript(_ view: UIView) -> MittyQuest {

        let m = MittyQuest()
        for c in controls {
            if (c.view === view) {
                m.controls.insert(c)
                return m
            }
        }
        let newControl = Control(view: view)
        controls.insert(newControl)
        m.controls.insert(newControl)
        return m
    }
    
    // define a protocol that can
    func forEach (_ selector: ControlSelector, _ operation: (_ selected: Control) -> Void) -> MittyQuest {
        let m = MittyQuest()
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
    func bindEvent (for event: UIControlEvents, _ handler: @escaping EventHandler ) -> MittyQuest {
        for c in controls {
            c.event(event, handler)
        }
        return self
        
    }
    
    // Special for button
    func button(_ selector: ControlSelector, onTap: @escaping EventHandler) -> MittyQuest {
        
        let m = MittyQuest()
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
    func textField(_ selector: ControlSelector, onFocus: @escaping EventHandler) -> MittyQuest {
        let m = MittyQuest()
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
    func textField(_ selector: ControlSelector, validator: Validator) -> MittyQuest {
        let m = MittyQuest()
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
    func animate(_ selector: ControlSelector, animator: () -> Void, duration: Int) -> MittyQuest {
        return self
    }
    
    // enable
    // disable
    // hide
    // remove
    
    func ifThen(_ selector: ControlSelector, ifTrue: Conditionor, thenDo: ControlOperation) -> MittyQuest {
        let m = MittyQuest()
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

extension MittyQuest {
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

public func MQ(_ form: MittyForm) -> MittyQuest {
    return form.mitty()
}

public func MQ(_ section: Section) -> MittyQuest {
    let mitty = MittyQuest()
    var opSet = mitty as OperationSet
    opSet += section.selectAll()
    return mitty
}

public func MQ(_ row: Row) -> MittyQuest {
    let mitty = MittyQuest()
    var opSet = mitty as OperationSet
    opSet += row.selectAll()
    return mitty
}

public func MQ(_ col: Col) -> MittyQuest {
    let mitty = MittyQuest()
    var opSet = mitty as OperationSet
    opSet += col.selectAll()
    return mitty
}

class MittyUIViewController : UIViewController {

    var rootMitty : MittyQuest
    
    init() {
        rootMitty = MittyQuest()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    public func mitty(_ view: UIView) -> MittyQuest {
        return rootMitty[view]
    }
    
    func mitty() -> MittyQuest {
        now("Start Travel.....")
        let rootView = self.view
        
        let m = MittyQuest()
        rootMitty = m
        if (rootView == nil) {
            return m
        }
        
        //let c = ControlManager.retrieveControl(vc: self, view: rootView!)
        let c = Control(view: rootView!)
        
        m.controls.insert(c)
        
        for vx in rootView!.subviews {
            travel(vx, m)
        }
        now("End Travel.....")
        return m
    }
    
    //
    func mity(_ selector: String) -> MittyQuest {
        return MittyQuest()[selector]
    }
    
    @discardableResult
    internal func travel(_ v: UIView, _ mitty: MittyQuest) -> MittyQuest {
        
        //let c = ControlManager.retrieveControl(vc: self, view: rootView!)
        let c = Control(view: v)
        
        mitty.controls.insert(c)
        for vx in v.subviews {
            travel(vx, mitty)
        }
        
        return mitty
        
    }

    func now(_ msg: String? = "") {
        let now = NSDate()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        let string = formatter.string(from: now as Date) + ":" + msg!
        
        print(string)
    }
    
    deinit {
        now("<MittyUIController:> " + self.description + " destroyed.")
    }
}
