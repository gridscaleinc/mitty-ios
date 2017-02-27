//
//  Form.swift
//  mitty
//
//  Created by gridscale on 2017/02/25.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit


typealias  EventHandler = (_ view: UIView) -> Void
enum FormEvent {
    case onTap
    case onChanged
}

class Control : NSObject {
    let field: UIView
    var handlers : [FormEvent: EventHandler] = [:]
    
    init(_ view: UIView) {
        field = view
        super.init()
    }
}

@objc(Form)
class Form : UIView, UIGestureRecognizerDelegate {
    
    // 画面のヘッダー部
    var header : UIView? {
        get{ return self.header }
        set(h){ self.header = h}
    }

    // ヘッダー有無判定
    var hasHeader : Bool {
        get{ return self.header != nil}
    }
    
    
    // 画面のFooterー部
    var footer : UIView? {
        get{ return self.footer }
        set(f){ self.footer = f}
    }
    
    // Footer有無判定
    var hasFooter : Bool {
        get{ return self.footer != nil}
    }
    
    var controls : [UIView : Control] = [:]
    
    // Event Registeration
    func registerHandler (_ view: UIView, _ event: FormEvent, _ handler: @escaping EventHandler) {
        var c = controls[view]
        if (c == nil) {
            c = Control(view)
            controls[view] = c
        }
    
        c!.handlers[event] = handler
        
        switch event {
        case .onTap:
            let tap = UITapGestureRecognizer(target: self, action: #selector(Form.handleTap(_:)))
            tap.delegate = self
            view.addGestureRecognizer(tap)
            
        case .onChanged:
            let t = view.self
            switch t {
            case is UITextField:
                let tf = view as! UITextField
                tf.addTarget(self, action: #selector(Form.textFieldDidChange(field:)), for: UIControlEvents.editingChanged)
            case is UIStepper:
                let stepper = view as! UIStepper
                stepper.addTarget(self, action: #selector(Form.textFieldDidChange(field:)), for: UIControlEvents.valueChanged)
            default:
                print("This filed dont support changed event")

            }
        }
    }
    
    // Event Dispatching
    func dispatchEvent (_ view: UIView, _ event: FormEvent) {
        let c = controls[view]
        c?.handlers[event]?(view)
    }
    
    // Tap処理
    func handleTap(_ ges: UITapGestureRecognizer) {
        dispatchEvent(ges.view!, .onTap)
    }
    
    // 値の変化を処理
    func textFieldDidChange(field: UIView) {
        dispatchEvent(field, .onChanged)
    }
}
