//
//  Controls.swift
//
//  MittyQuest
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


// Abstract class that modeling a tree structure.
protocol Node : class {
    var name : String {get}
    var view : UIView {get}
    var children : [Control] { get }
    var parent : Control? { get set}
    var elderSibling : Control? {get}
    var youngerSibling : Control? {get}
}

//
// Control.
// Control Class , A point of layout, event handling, and other operations
// with one or a set views behind.
//
open class Control : NSObject, Node, Operatable {

    private var _name : String = ""
    internal var _parent: Control?
    
    internal var _view: UIView
    
    open var margin = ControlMargin()
    
    // properties
    var name : String { return _name }
    
    var view: UIView { return _view }
    
    // parent control
    var parent: Control? {
        get { return _parent}
        set (p) {
            _parent = p
        }
    }
    
    // sub controls
    internal var children : [Control] = []
    
    // construct a default named control
    public init(view: UIView) {
        self._view = view
        if (view.tag == 0) {
            view.tag = nextTag()
        }
        _name = "Node#" + String(view.tag)
    }
    
    // initalize control using name and specific view
    public init(name: String, view v: UIView) {
        _name = name
        if (v.tag == 0) {
            v.tag = nextTag()
        }
        self._view = v
        super.init()
    }
    
    // Initializer, using name only with default UIView underly.
    public convenience init(name: String) {
        self.init(name: name, view: UIView.newAutoLayout())
    }
    
    // Initializer, with no name , and a defulat UIView underly.
    public convenience override init() {
        self.init(name: "", view: UIView.newAutoLayout())
        self._name = type(of:self).description() + "\(_view.tag)"
    }
    
    // Computed Property elderSibling
    var elderSibling : Control? {
        if (_parent != nil) {
            let siblings = _parent?.children
            
            if let indexOfMe = siblings?.index(of: self) {
                return siblings?[(siblings?.index(before: indexOfMe))!]
            }
        }
        return nil
    }
    
    // Computed Property, YoungerSibling
    var youngerSibling : Control? {
        if (_parent != nil) {
            let siblings = _parent?.children
            
            if let indexOfMe = siblings?.index(of: self) {
                return siblings?[(siblings?.index(after: indexOfMe))!]
            }
        }
        return nil
    }
    
    // Property the stores Eventhandlers.
    private var delegators : [EventDelegator] = []
    
    // Property that stores layout operations.
    private var layoutCoders : [LayoutCoder] = []
    
    // Equalty Function, Make it conform to Equatable.
    static public func == (lhs: Control, rhs: Control) -> Bool {
        return lhs._name == rhs._name
        
    }
    
    // Make it conform to Hashable
    override open var hashValue: Int {
        return _name.hashValue
    }
    
    /*
     Make it conform to Operatable protocol
     registration Layout coder.
     The layout coder is registered only, it will not working until configLayout func
     called.
     */
    @discardableResult
    func layout(_ coder: @escaping LayoutCoder) -> Self {
        // not duplicatedly
        self.layoutCoders.append(coder)
        return self
    }
    
    /*
     Make it conform to Operatable protocol
     call operation future in background thread
     */
    @discardableResult
    func future(_ operation: @escaping (Operatable) -> Void, _ completion: (()->Void)? ) -> Self {
        // Call by async
        let queue = OperationQueue()
        queue.addOperation() {
            operation(self)
            // Async callback
            let callback = completion
            if callback != nil {
                OperationQueue.main.addOperation() {
                    callback!()
                }
            }
        }
        return self
        
    }
    
    /*
     Make it conform to Operatable protocol
     register event handler here
     */
    @discardableResult
    func bindEvent(_ event: UIControlEvents, _ handler: @escaping EventHandler) -> Self {

        let delegator = ControlEventDelegator()
        delegators.append(delegator)
        
        delegator.startDelegate(event, self, handler)
        
        return self
    }
    
    // config layout by previously registered layout coders.
    func configLayout () {
        for code in layoutCoders {
            code(self)
        }
    }
    
    // retrieve underlying UILabel view.
    // Its throws error if the underlying view is not conform to UILabel.
    var label : UILabel  {
        return _view as! UILabel
    }
    
    // retrieve underlying UITextField view.
    // Its throws error if the underlying view is not conform to UITextField.
    var textField : UITextField  {
        return _view as! UITextField
    }
    
    // retrieve underlying UITextView view.
    // Its throws error if the underlying view is not conform to UITextView.
    var textView : UITextView  {
        return _view as! UITextView
    }
    
    // retrieve underlying UIStepper view.
    // Its throws error if the underlying view is not conform to UIStepper.
    var stepper : UIStepper  {
        return _view as! UIStepper
    }
    
    // retrieve underlying UISwitch view.
    // Its throws error if the underlying view is not conform to UISwitch.
    var switcher : UISwitch  {
        return _view as! UISwitch
    }
    
    // retrieve underlying UIImageView view.
    // Its throws error if the underlying view is not conform to UIImageView.
    var image : UIImageView  {
        return _view as! UIImageView
    }
    
    // retrieve underlying UIButton view.
    // Its throws error if the underlying view is not conform to UIButton.
    var button : UIButton  {
        return _view as! UIButton
    }
}
