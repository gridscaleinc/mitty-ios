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
    case onEditEnded
}

typealias LayoutCoder = () ->Void
class Control : NSObject {
    let field: UIView
    var name: String = "NO-NAME"
    
    var handlers : [FormEvent: EventHandler] = [:]
    
    init(_ view: UIView) {
        field = view
        super.init()
    }
    
    init(_ name: String, _ view: UIView) {
        self.name = name
        field = view
        super.init()
    }
    
    var layoutCode : (LayoutCoder)? = nil
    
    func layout(_ coder: @escaping LayoutCoder) -> Control {
        self.layoutCode = coder
        return self
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
            
        //
        // TODO: また限られた種類しかできない。
        case .onChanged:
            let t = view.self
            switch t {
            case is UIControl :
                let tf = view as! UIControl
                tf.addTarget(self, action: #selector(Form.fieldDidChange(field:)), for: UIControlEvents.valueChanged)
            default:
                print("This filed dont support changed event")

            }
        case .onEditEnded:
            let t = view.self
            if t is UIControl {
                let tf = view as! UIControl
                tf.addTarget(self, action: #selector(Form.fieldDidEdit(field:)), for: UIControlEvents.editingDidEnd)
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
    func fieldDidChange(field: UIView) {
        dispatchEvent(field, .onChanged)
    }
    
    // 値の編集を処理
    func fieldDidEdit(field: UIView) {
        dispatchEvent(field, .onEditEnded)
    }
    
    static func setButtonStyle (button: UIButton) {
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.white, for: UIControlState.normal)
        button.setTitleColor(.gray, for: .disabled)
        button.backgroundColor = UIColor.lightGray
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.gray.cgColor
    }
    
    static func HL (parent: UIView, bottomOf: UIView, _ color: UIColor? = UIColor.black, _ width: Int = 1) -> UIView {
        let hl = UIView.newAutoLayout()
        hl.backgroundColor = color
        hl.autoSetDimension(.height, toSize: CGFloat(width))
        
        parent.addSubview(hl)
        hl.autoPinEdge(.top, to: .bottom, of:bottomOf)
        hl.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
        hl.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        
        return hl
    }
}
