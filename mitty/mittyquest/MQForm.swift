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
    
    // コントロールの順序を保ったクレクション
    var controls: [Control] = []
    
    // アサイメント計算
    static func += (left: inout MQForm, control: Control) {
        left.append(control)
    }
    
    // 足し算
    @discardableResult
    static func +++ (left: MQForm, right: Control) -> MQForm {
        var f = left
        f += right
        return left
    }
    
    // 足す
    func append(_ control: Control) {
        controls.append(control)
        addSubview(control.view)
    }
    
    // 
    // コントロール名よりコントロール取得。
    // このフォームに含まれるすべてのコントロールから名称が一致するものの一番最初に見つけたのを返す。
    subscript(_ name: String) -> Control? {
        return quest("[name=\(name)]").control()
    }
    
    // Label
    static func  label (name: String, title: String) -> Control {
        let l = TapableLabel.newAutoLayout()
        l.text = title
        return Control(name: name, view: l)
    }
    
    // TextField
    static func text(name: String, placeHolder: String) -> Control {
        let t = StyledTextField.newAutoLayout()
        t.hilightedLineColor = UIColor.blue.cgColor
        t.placeholder = placeHolder
        t.backgroundColor = .white
        let c = Control(name: name, view: t)
        
        return c
    }
    
    // TextView
    static func textView(name: String) -> Control {
        let t = UITextView.newAutoLayout()
        t.layer.borderColor = UIColor.gray.cgColor
        t.layer.borderWidth = 0.5
        
        let c = Control(name: name, view: t)
        return c
    }
    
    // Button
    static func button(name: String, title: String ) -> Control {
        let button = UIButton.newAutoLayout()
        button.setTitle(title, for: UIControlState())
        button.backgroundColor = .orange
        button.layer.cornerRadius = 3
        return Control(name: name, view:button)
    }
    
    // Image
    static func img(name: String, url: String ) -> Control {
 
        let img = UIImageView.newAutoLayout()
        img.image = UIImage(named: url)
        
        return Control(name: name, view: img)

    }
    
    // Stepper
    static func stepper (name: String, min: Double, max: Double) -> Control {
        let stepper = UIStepper.newAutoLayout()
        stepper.minimumValue = min
        stepper.maximumValue = max
        stepper.stepValue = 1
        stepper.tintColor = .lightGray
        stepper.value = 2019
        return Control(name: name , view:stepper)
    }
    
    // Switchs
    static func switcher(name: String, value: Bool? = false) -> Control {
        let sw = UISwitch.newAutoLayout()
        sw.isOn = value!
        
        return Control(name: name, view: sw)
        
    }
    
    // Quest by selector
    func quest(_ selector: String) -> MittyQuest {
        return quest()[selector]
    }

    // Build the Quest of all controlls in form
    func quest() -> MittyQuest {
        let rootMitty = MittyQuest()
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
    
    // Doing configuration of layouts
    func configLayout() {
        for c in controls {
            c.configLayout()
        }
    }
    
    // 
    // フォームの主要部を構成するスクロールコンテナーコントロルを作成
    //
    func scrollContainer(name: String, contentSize: CGSize) -> Container {
        let scroll = UIScrollView.newAutoLayout()
        scroll.contentSize = contentSize
        scroll.isScrollEnabled = true
        scroll.flashScrollIndicators()
        scroll.canCancelContentTouches = false
        
        let container = Container(name: name, view: scroll)
        
        return container
    }
    
}
