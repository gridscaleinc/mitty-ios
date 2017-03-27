//
//  MQForm.swift
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

@objc(MQForm)
open class MQForm : UIView {
    var rootMitty = MittyQuest()
    var controls: [Control] = []
    var controlDictionary : [String: Control] = [:]
    
    static func += (left: inout MQForm, control: Control) {
        left.append(control)
    }
    
    @discardableResult
    static func +++ (left: MQForm, right: Control) -> MQForm {
        var f = left
        f += right
        return left
    }
    
    var controlCount : Int { return controls.count }
    
    func append(_ control: Control) {
        controls.append(control)
        controlDictionary[control.name] = control
        addSubview(control.view)
    }
    
    subscript(_ name: String) -> Control? {
        return quest("[name=\(name)]").control()
    }
    
    func  label (name: String, title: String) -> Control {
        let l = TapableLabel.newAutoLayout()
        l.text = title
        return Control(name: name, view: l)
    }
    
    ///
    func text(name: String, placeHolder: String, width: CGFloat) -> Control {
        let t = StyledTextField.newAutoLayout()
        t.hilightedLineColor = UIColor.blue.cgColor
        t.placeholder = placeHolder
        t.backgroundColor = .white
        return Control(name: name, view: t).width(width)
    }
    
    func button(name: String, title: String ) -> Control {
        let button = UIButton.newAutoLayout()
        button.setTitle(title, for: UIControlState())
        MQForm.setButtonStyle(button: button)
        return Control(name: name, view:button)
    }
    
    func img(name: String, url: String ) -> Control {
 
        let img = UIImageView.newAutoLayout()
        img.contentMode = UIViewContentMode.scaleAspectFit
        
        img.image = UIImage(named: url)
        
        return Control(name: name, view: img)

    }
    
    func stepper (name: String, min: Double, max: Double) -> Control {
        let stepper = UIStepper.newAutoLayout()
        stepper.minimumValue = min
        stepper.maximumValue = max
        stepper.stepValue = 1
        stepper.tintColor = .lightGray
        stepper.value = 2019
        return Control(name: name , view:stepper)
    }
 
    
    //
    func quest(_ selector: String) -> MittyQuest {
        return quest()[selector]
    }

    func quest() -> MittyQuest {
        rootMitty = MittyQuest()
        var opSet = rootMitty as OperationSet
        for c in controls {
            if (c is Container) {
                opSet += (c as! Container).selectAll()
            } else {
                opSet.controls.insert(c)
            }
        }
        return rootMitty
    }
    
    func configLayout() {
        for c in controls {
            c.configLayout()
        }
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
    
    
}
