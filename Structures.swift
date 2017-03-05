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
    var sections: [Section1] = []
    var sectionDictionary : [String: Section1] = [:]
    
    static func += (left: inout MittyForm, section: Section1) {
        left.append(section)
    }
    
    @discardableResult
    static func +++ (left: MittyForm, right: Section1) -> MittyForm {
        var f = left
        f += right
        return left
    }
    
    var sectionCount : Int { return sections.count }
    
    
    func append(_ section: Section1) {
        sections.append(section)
        sectionDictionary[section.name] = section
    }
    
    subscript(_ name: String) -> Section1? {
        return sectionDictionary[name]
    }
    
    // Section
    subscript (_ index: Int) -> Section1 {
        return sections[index]
    }
    
    // Section/Row
    subscript (_ s: Int, _ r: Int) -> Container1 {
        return sections[s][r]
    }
    
    // TODO:いるかな？
    private static func <<< (left: inout MittyForm, right: Container1) -> MittyForm {
        let s = left.sections
        if (s.count > 0) {
            let section = s[s.count - 1];
            section +++ right
            return left
        } else {
            let section = Section1(view: UIView()) // 名前なしセクションを作成
            left +++ section
            section +++ right
            return left
        }
        
    }
    
}


open class Container1 : Control1, Selectable {
    
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
        return select() { (c: Control1) in
            return c.name == named
        }
    }
    
    func select(_ selector: String) -> OperationSet {
        return select() { (c: Control1) in
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
    func select(_ selector: (Control1) -> Bool) -> OperationSet {
        var set = OperationSet.empty()
        if (selector(self)) {
            set.controls.insert(self)
        }
        for c in children {
            let t = type(of: c)
            if t is Container1.Type {
                let s = (c as! Container1).select(selector)
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
    static func +=(left: inout Container1, right: Control1) {
        left.view.addSubview(right.view)
        left.children.append(right)
        right.parent = left
    }
    
    // asssignment operator
    @discardableResult
    static func +++ (left: Container1, right: Control1) -> Container1 {
        left.view.addSubview(right.view)
        left.children.append(right)
        right.parent = left
        return left
    }
    
    // asssignment operator
    static func -=(left: inout Container1, right: Control1) {
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
            
            for c in Array<Control1>(children.reversed()) {
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

open class Row1 : Container1 {
    
    //
    static func GEN(_ align: LeftRight) -> Row1 {
        let row = Row1()

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
    static func LeftAlignedRow () -> Row1 {
        return GEN(.leftAligned)
    }
    
    //
    static func RightAlignedRow () -> Row1 {
        return GEN(.rightAligned)
    }
}

open class Col : Container1 {
    
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

open class Section1 : Container1 {
    private var _title = ""
    private var _titleControl :Control1? = nil
    private var contents : [Container1] = []
    
    var title : String {
        get { return _title }
        set(newValue) {
            self._title = newValue
        }
    }
    
    var titleConrol : Control1? {
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
    
    subscript (_ index: Int) -> Container1 {
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
    
    static func += (left: inout Section1, right: Container1) {
        left.children.append(right)
        left.contents.append(right)
    }
    static func += (left: inout Section1, right: Row1) {
        left.children.append(right)
        left.contents.append(right)
    }
    
    @discardableResult
    static func +++ (left: Section1, right: Container1) -> Section1 {
        var section = left
        section += right
        return left
    }
    
    @discardableResult
    static func +++ (left: Section1, right: Row1) -> Section1 {
        var section = left
        section += right
        return left
    }
    
    func add(row: Container1, alignment align: LeftRight = .leftAligned) {
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
    
    func add(col: Container1, alignment align: UpBottom) {
        
    }
}
