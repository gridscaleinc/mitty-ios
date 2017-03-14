//
//  EventDispatcher.swift
//  mitty
//
//  Created by gridscale on 2017/03/06.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

enum FormEvent {
    case onTap
    case onChanged
    case onEditEnded
    case onFocus
}


//
//
//
protocol EventDispatcher {
    func dispatch(_ id: FormEvent, view: UIView)
}

protocol UIControlEventsDispatcher {
    func dispatch(_ event: UIControlEvents, view: UIView)
}


//
//
//
protocol EventDelegator  {
    func saveHandler(_ handler :@escaping EventHandler)
    func startDelegate (_ event: UIControlEvents , _ control: Control, _ handler: @escaping EventHandler)
}

class ControlEventDelegator :EventDelegator {
    func startDelegate(_ event: UIControlEvents , _ control: Control, _ handler: @escaping EventHandler) {
     
        saveHandler(handler)
        
        let t = control.view.self
        switch t {
        case is UIControl :
            let tf = control.view as! UIControl
            tf.addTarget(self, action: #selector(dispatchEvent(_ :)), for: event)
        default:
            print("This filed dont support changed event")
        }
    }
    
    var handler : EventHandler? = nil
    
    func saveHandler(_ handler : @escaping EventHandler) {
        self.handler = handler
    }

    // Event Dispatching
    @objc
    func dispatchEvent (_ view: UIView) {
        handler?(view)
    }
    
}

