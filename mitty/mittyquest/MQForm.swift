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
import PureLayout
import SkyFloatingLabelTextField

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
    static func  label (name: String, title: String, color:UIColor? = MittyColor.labelColor, pad: CGFloat? = 0) -> Control {
        let l = TapableLabel.newAutoLayout()
        l.text = title
        l.textColor = color
        l.baselineAdjustment = .alignBaselines
        l.pad(with: pad!)
        return Control(name: name, view: l)
    }
    
    // Title
    static func  titleRow (name: String, caption: String, color: UIColor? = UIColor.black, lineColor: UIColor?=UIColor.darkGray) -> Row {
        let row = Row.LeftAligned().layout {
            r in
            r.leftMost(withInset: 10).height(50).leftMargin(10).rightMargin(7)
        }
        
        row +++ label(name: name, title: caption, color:color).layout{
            l in
            l.label.font = UIFont.boldSystemFont(ofSize: 20)
            l.down(withInset: 3).rightMost().leftMargin(10)
        }
        
        row +++ HL(lineColor, 1).layout {
            l in
            l.down().fillHolizon()
        }
        
        return row
    }
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - label: <#label description#>
    ///   - name: <#name description#>
    /// - Returns: <#return value description#>
    static func hilight (label: String, named name: String) -> Control {
        let l = MQForm.label(name: name, title: label)
        
        l.label.textAlignment = .center
        l.label.backgroundColor = UIColor.white
        l.label.layer.borderColor = MittyColor.sunshineRed.cgColor
        l.label.layer.borderWidth = 0.5
        l.label.layer.cornerRadius = 15
        l.label.layer.masksToBounds = true
        l.height(30)
        l.label.textColor = MittyColor.sunshineRed
        
        return l
    }
    
    // TextField
    static func text(name: String, placeHolder: String) -> Control {
        let t = SkyFloatingLabelTextField.newAutoLayout()
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
        button.setTitleColor(MittyColor.sunshineRed, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 3
        return Control(name: name, view:button)
    }
    
    // Image
    static func img(name: String, url: String ) -> Control {
 
        let img = UIImageView.newAutoLayout()
        img.image = UIImage(named: url)
        
        return Control(name: name, view: img)

    }
    
    // TapableImage
    static func tapableImg(name: String, url: String ) -> Control {
        
        let img = TapableUIImageView.newAutoLayout()
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
    
    static func section(name: String) -> Section {
        let section = Section(name: name, view: UIView.newAutoLayout())
        return section
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
    

    func fillIn(vc: UIViewController , inset : CGFloat = 0) {
        vc.view.addSubview(self)
        self.autoPin(toTopLayoutGuideOf: vc, withInset: inset)
        self.autoPin(toBottomLayoutGuideOf: vc, withInset: inset)
        self.autoPinEdge(toSuperviewEdge: .left, withInset: inset)
        self.autoPinEdge(toSuperviewEdge: .right, withInset: inset)
    }
    
}
