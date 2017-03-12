//
//  Form.swift
//  mitty
//
//  Created by gridscale on 2017/03/04.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

@objc(MittyForm)
open class MittyForm : UIView {
    var sections: [Section] = []
    var sectionDictionary : [String: Section] = [:]
    
    static func += (left: inout MittyForm, section: Section) {
        left.append(section)
    }
    
    @discardableResult
    static func +++ (left: MittyForm, right: Section) -> MittyForm {
        var f = left
        f += right
        return left
    }
    
    var sectionCount : Int { return sections.count }
    
    
    func append(_ section: Section) {
        sections.append(section)
        sectionDictionary[section.name] = section
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
    private static func <<< (left: inout MittyForm, right: Container) -> MittyForm {
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
    
}


open class Container : Control, Selectable {
    
    enum Distribution {
        case leftAligned
        case rightAligned
        case upAligned
        case bottomAligned
    }
    
    private var _distributionMode : Distribution = .leftAligned
    
    var distribution : Distribution {
        get {
            return _distributionMode
        }
        set (newValue) {
            _distributionMode = newValue
        }
    }
    
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
    
    /*
     * distribute children controls by alignment mode
     */
    func distribute () {
        
        if children.count == 0 {
            return
        }
        
        switch distribution {
        case .leftAligned, .upAligned:
            let first = children.first
            var previous = first
            
            for c in children {
                if (c === first) {
                    _ = (distribution == .upAligned) ? c.upper() : c.leftMost()
                } else {
                    _ = distribution == .upAligned ? c.putUnder(of: previous!, withOffset: 3 + c.margin.up)
                        : c.righter(than: previous!, withOffset: 3 + c.margin.left)
                }
                previous = c
            }
        case .rightAligned, .bottomAligned:
            let last = children.last
            var previous = last
            
            for c in Array<Control>(children.reversed()) {
                if (c === last) {
                    _ = (distribution == .bottomAligned) ? c.down() : c.rightMost()
                } else {
                    _ = (distribution == .bottomAligned) ? c.putAbove(Of: previous!, withOffset: 3 + c.margin.bottom)
                        : c.lefter(than: previous!, withOffset: 3 + c.margin.right)
                }
                previous = c
            }
        }
    }
}

open class Row : Container {
    
    //
    static func GEN(_ align: LeftRight) -> Row {
        let row = Row()

        switch (align) {
        case LeftRight.rightAligned:
            row.distribution = .rightAligned
        default:
            row.distribution = .leftAligned
            return row
        }
        
        return row
    }
    
    //
    static func LeftAlignedRow () -> Row {
        return GEN(.leftAligned)
    }
    
    //
    static func RightAlignedRow () -> Row {
        return GEN(.rightAligned)
    }
}

open class Col : Container {
    
    //
    static func GEN(_ align: UpBottom) -> Col {
        let col = Col()
        
        switch (align) {
        case UpBottom.bottom:
            col.distribution = .bottomAligned
        default:
            col.distribution = .upAligned
            return col
        }
        
        return col
    }
    
    //
    static func UpDownAlignedCol () -> Col {
        return GEN(.up)
    }
    
    //
    static func BottomUpAlignedCol () -> Col {
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
        left.children.append(right)
        left.contents.append(right)
    }
    static func += (left: inout Section, right: Row) {
        left.children.append(right)
        left.contents.append(right)
    }
    
    @discardableResult
    static func +++ (left: Section, right: Container) -> Section {
        var section = left
        section += right
        return left
    }
    
    @discardableResult
    static func +++ (left: Section, right: Row) -> Section {
        var section = left
        section += right
        return left
    }
    
    func add(row: Container, alignment align: LeftRight = .leftAligned) {
        switch align {
        case LeftRight.leftAligned:
            row.distribution = .leftAligned
        case LeftRight.rightAligned:
            row.distribution = .leftAligned
        default: return
        }
        
        children.append(row)
        
        contents.append(row)
    }
    
    func add(col: Container, alignment align: UpBottom) {
        
    }
}
