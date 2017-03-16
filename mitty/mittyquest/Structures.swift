//
//  Strutures.swift
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

open class Container : Control, Selectable {
    

    subscript (named: String) -> OperationSet {
        return select() { (c: Control) in
            return c.name == named
        }
    }
    
    func select(_ selector: String) -> OperationSet {
        return select() { (c: Control) in
            return c.name == selector
        }
    }
    
    /**  */
    func selectAll() -> OperationSet {
        return select() {c in
            return true
        }
    }
    
    @nonobjc
    func select(_ selector: (Control) -> Bool) -> OperationSet {
        var set = OperationSet.empty()
        if (selector(self)) {
            set.controls.insert(self)
        }
        for c in children {
            let t = type(of: c)
            if t is Container.Type {
                let s = (c as! Container).select(selector)
                if (!s.controls.isEmpty) {
                    set += s
                }
            } else {
                if (selector(c)) {
                    set.controls.insert(c)
                }
            }
        }
        return set
    }
    
    // asssignment operator
    static func +=(left: inout Container, right: Control) {
        left.view.addSubview(right.view)
        left.children.append(right)
        right.parent = left
    }
    
    // asssignment operator
    @discardableResult
    static func +++ (left: Container, right: Control) -> Container {
        left.view.addSubview(right.view)
        left.children.append(right)
        right.parent = left
        return left
    }
    
    // asssignment operator
    static func -=(left: inout Container, right: Control) {
        if (left.children.contains(right)) {
            if (left.view.subviews.contains(right.view)) {
                right.view.removeFromSuperview()
            }
            
            if let index = left.children.index(of: right) {
                left.children.remove(at: index)
            }
            
            right.parent = nil
        }
    }
    /**
     Configure container layout
     */
    override func configLayout () {
        super.configLayout()
        
        for child in children {
            child.configLayout()
        }
        
        distribute()
        
    }
    
    func distribute () {
        
    }
    
}

open class Row : Container {
    
    private var _distributionMode : LeftRight = .left
    
    var distribution : LeftRight {
        get {
            return _distributionMode
        }
        set (newValue) {
            _distributionMode = newValue
        }
    }
    
    /*
     * distribute children controls by alignment mode
     */
    override func distribute () {
        
        if children.count == 0 {
            return
        }
        
        switch distribution {
        case .left:
            let first = children.first
            var previous = first
            
            for c in children {
                if (c === first) {
                    c.leftMost()
                } else {
                     c.righter(than: previous!, withOffset: c.margin.left)
                }
                previous = c
            }
        case .right:
            let last = children.last
            var previous = last
            
            for c in Array<Control>(children.reversed()) {
                if (c === last) {
                    c.rightMost()
                } else {
                    c.lefter(than: previous!, withOffset: c.margin.right)
                }
                previous = c
            }
        }
    }
    
    //
    static func GEN(_ align: LeftRight) -> Row {
        let row = Row()
        row.distribution = align
        return row
    }
    
    //
    static func LeftAligned () -> Row {
        return GEN(.left)
    }
    
    //
    static func RightAligned() -> Row {
        return GEN(.right)
    }
}

open class Col : Container {
    
    private var _distributionMode : UpBottom = .up
    
    var distribution : UpBottom {
        get {
            return _distributionMode
        }
        set (newValue) {
            _distributionMode = newValue
        }
    }
    
    
    /*
     * distribute children controls by alignment mode
     */
    override func distribute () {
        
        if children.count == 0 {
            return
        }
        
        switch distribution {
        case .up:
            let first = children.first
            var previous = first
            
            for c in children {
                if (c === first) {
                    c.upper()
                } else {
                    c.putUnder(of: previous!, withOffset: (c.margin.up))
                }
                previous = c
            }
        case .bottom:
            let last = children.last
            var previous = last
            
            for c in Array<Control>(children.reversed()) {
                if (c === last) {
                    c.down()
                } else {
                    c.putAbove(Of: previous!, withOffset: c.margin.bottom)
                }
                previous = c
            }
        }
    }

    //
    static func GEN(_ align: UpBottom) -> Col {
        let col = Col()
        col.distribution = align
        return col
    }
    
    //
    static func UpDownAligned () -> Col {
        return GEN(.up)
    }
    
    //
    static func BottomUpAligned () -> Col {
        return GEN(.bottom)
    }
}

open class Section : Container {
    private var _title = ""
    private var _titleControl :Control? = nil
    private var contents : [Container] = []
    
    var title : String {
        get { return _title }
        set(newValue) {
            self._title = newValue
        }
    }
    
    var titleConrol : Control? {
        get { return _titleControl }
        set(newValue) {
            self._titleControl = newValue
        }
    }
    
    var titleLayoutCode : (() -> Void)?
    
    override func configLayout () {
        super.configLayout()
        configTitleLayout()
    }
    
    subscript (_ index: Int) -> Container {
        return contents[index]
    }
    
    var count: Int { return contents.count}
    
    override func selectAll() -> OperationSet {
        var set = super.selectAll()
        if (titleConrol != nil) {
            set += titleConrol!
        }
        return set
    }
    
    /**
     */
    func configTitleLayout() {
        titleLayoutCode?()
    }
    
    static func += (left: inout Section, right: Container) {
        left.append(right)
    }
    
    static func += (left: inout Section, right: Row) {
        left += right as Container
    }
    
    static func += (left: inout Section, right: Col) {
        left += right as Container
    }
    
    @discardableResult
    static func +++ (left: Section, right: Container) -> Section {
        var section = left
        section += right
        return left
    }
    
    @discardableResult
    static func +++ (left: Section, right: Row) -> Section {
        return left +++ (right as Container)
    }
    
    @discardableResult
    static func +++ (left: Section, right: Col) -> Section {
        return left +++ (right as Container)
    }
    
    func add(row: Row, alignment align: LeftRight = .left) {
        row.distribution = align
        append(row)
    }
    
    func add(col: Col, alignment align: UpBottom) {
        col.distribution = align
        append(col)
    }
    
    func append(_ c: Container) {
        children.append(c)
        contents.append(c)
        c.parent = self
    }
}

func HL (_ color: UIColor? = UIColor.black, _ width: Int? = 1) -> UIView {
    let hl = UIView.newAutoLayout()
    hl.backgroundColor = color
    hl.autoSetDimension(.height, toSize: CGFloat(width!))
    
    return hl
}

class Header: Section {
    init(_ title: String ) {
        super.init(name: "Header-Section", view: UIView())
        super.title = title
        super.titleConrol = Control(view :HL())
        self.view.addSubview((titleConrol?.view)!)
    }
}
