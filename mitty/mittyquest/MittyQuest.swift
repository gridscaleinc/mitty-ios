//
//  MittyQuest.swift
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

//
//
//
open class MittyQuest : OperationSet {

    internal override init() {
        super.init()
    }
    
    open subscript(_ selector: String) -> MittyQuest {
        let matching = compile(selector)
        let m = MittyQuest()
        if (matching.hasError) {
            return m
        }
        let matched = matching.selector.matchAll(self.controls)
        m.controls = m.controls.union(matched)
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
    
    // return the first control in current set
    func control() -> Control? {
        return controls.first
    }
    
    // return the first control's view in currenct set
    func view() -> UIView? {
        return controls.first?.view
    }
    
    // return the first textField view in currenct set
    func first<V>() -> V? {
        for c in controls {
            if c.view is V {
                return c.view as? V
            }
        }
        return nil
    }
    
    // return the first textField view in currenct set
    func controlOf<V:UIView>(_ v: V) -> Control? {
        for c in controls {
            if c.view is V {
                return c
            }
        }
        return nil
    }
    
    // define a protocol that can
    @discardableResult
    func forEach (_ selector: String? = nil, _ operation: (_ selected: Control) -> Void) -> MittyQuest {
        let mitty = (selector != nil) ? self[selector!] : self
        
        for c in mitty.controls {
            operation(c)
        }
        return mitty
    }
    
    // define a function that access all the values in selectable
    func val(_ value: Any) -> AnyObject  {
        return self
    }
    
    // event bind
    @discardableResult
    func bindEvent (_ selector: String? = nil, for event: UIControlEvents, _ handler: @escaping EventHandler ) -> MittyQuest {
        
        let mitty = (selector != nil) ? self[selector!] : self
        
        for c in mitty.controls {
            c.bindEvent(event, handler)
        }
        return mitty
        
    }

    /*
     Make it conform to Operatable protocol
     registration Layout coder
     */
    @discardableResult
    func layout(_ selector: String? = nil, _ coder: @escaping LayoutCoder) -> MittyQuest {
        
 
        let mitty = (selector != nil) ? self[selector!] : self
        
        for c in mitty.controls {
            c.layout(coder)
        }
        return mitty
    }

    //
    @discardableResult
    func animate(_ selector: String? = nil, animator: () -> Void, duration: Int) -> MittyQuest {
        return self
    }
    
    // enable
    // disable
    // hide
    // remove
    
    func ifThen(_ selector: String? = nil, ifTrue: Conditionor, thenDo: ControlOperation) -> MittyQuest {
        
        let mitty = (selector != nil) ? self[selector!] : self
        
        for c in mitty.controls {
            if (ifTrue(c)) {
                thenDo(c)
            }
        }
        return mitty
    }
    
}

extension MittyQuest {
    func compile(_ selection: String) -> Matching {
        let pattern = selection.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let m = Matching(pattern)
        return m
    }
}

public func MQ(_ form: MQForm) -> MittyQuest {
    return form.quest()
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
    public func MQ(_ view: UIView) -> MittyQuest {
        return rootMitty[view]
    }
    
    func MQ() -> MittyQuest {
        now("Start Travel.....")
        let rootView = self.view
        if (rootView is MQForm) {
            rootMitty = (rootView as! MQForm).quest()
            return rootMitty
        }
        
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
    func MQ(selector: String) -> MittyQuest {
        return MQ()[selector]
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
