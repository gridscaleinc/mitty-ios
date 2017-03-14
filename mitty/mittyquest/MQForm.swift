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
    var sections: [Section] = []
    var sectionDictionary : [String: Section] = [:]
    
    static func += (left: inout MQForm, section: Section) {
        left.append(section)
    }
    
    @discardableResult
    static func +++ (left: MQForm, right: Section) -> MQForm {
        var f = left
        f += right
        return left
    }
    
    var sectionCount : Int { return sections.count }
    
    
    func append(_ section: Section) {
        sections.append(section)
        sectionDictionary[section.name] = section
        addSubview(section.view)
    }
    
    subscript(_ name: String) -> Section? {
        return sectionDictionary[name]
    }
    
    // Section
    subscript (_ index: Int) -> Section {
        return sections[index]
    }
    
    // Section/Row
    subscript (_ s: Int, _ r: Int) -> Container {
        return sections[s][r]
    }
    
    // TODO:いるかな？
    private static func <<< (left: inout MQForm, right: Container) -> MQForm {
        let s = left.sections
        if (s.count > 0) {
            let section = s[s.count - 1];
            section +++ right
            return left
        } else {
            let section = Section(view: UIView()) // 名前なしセクションを作成
            left +++ section
            section +++ right
            return left
        }
    }
    
    func mitty() -> MittyQuest {
        let rootMitty = MittyQuest()
        var opSet = rootMitty as OperationSet
        for s in sections {
            opSet += s.selectAll()
        }
        return rootMitty
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
