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

open class Container: Control, Selectable {

    subscript (named: String) -> Control? {
        let set = select() { (c: Control) in
            return c.name == named
        }
        if set.controls.isEmpty {
            return nil
        }
        return set.controls.first
    }

    func select(_ selector: String) -> OperationSet {
        return select() { (c: Control) in
            return c.name == selector
        }
    }

    /**  */
    func selectAll() -> OperationSet {
        return select() { c in
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
    static func += (left: inout Container, right: Control) {
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
    static func -= (left: inout Container, right: Control) {
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

open class Row: Container {

    private var _distributionMode: LeftRight = .left
    private var _spacing: CGFloat = 0

    var distribution: LeftRight {
        get {
            return _distributionMode
        }
        set (newValue) {
            _distributionMode = newValue
        }
    }


    var spacing: CGFloat {
        get {
            return _spacing
        }
        set (newValue) {
            _spacing = newValue
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
                    c.leftMost(withInset: spacing + c.margin.left)
                } else {
                    c.righter(than: previous!, withOffset: previous!.margin.right + spacing + c.margin.left)
                }
                previous = c
//                c.upper(withInset: c.margin.up)
            }
        case .right:
            let last = children.last
            var previous = last

            for c in Array<Control>(children.reversed()) {
                if (c === last) {
                    c.rightMost(withInset: spacing + c.margin.right)
                } else {
                    c.lefter(than: previous!, withOffset: previous!.margin.left + spacing + c.margin.right)
                }
                previous = c
//                c.upper(withInset: c.margin.up)
            }
        case .atIntervals:
            let views = self.view.subviews as NSArray
            let first = children.first
            let horizontalLayoutConstraints = NSLayoutConstraint.autoCreateAndInstallConstraints {
//                views.autoSetViewsDimension(.height, toSize: 40.0)
                views.autoDistributeViews(along: .horizontal, alignedTo: .horizontal, withFixedSpacing: spacing, insetSpacing: true, matchedSizes: true)
                first?.view.autoPinEdge(toSuperviewEdge: .bottom, withInset: first?.margin.bottom ?? 0)
            } as NSArray?
            horizontalLayoutConstraints?.autoInstallConstraints()
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

    //
    static func Intervaled() -> Row {
        return GEN(.atIntervals)
    }
}

open class Col: Container {

    private var _distributionMode: UpBottom = .up
    private var _spacing: CGFloat = 0.0

    var distribution: UpBottom {
        get {
            return _distributionMode
        }
        set (newValue) {
            _distributionMode = newValue
        }
    }

    var spacing: CGFloat {
        get {
            return _spacing
        }
        set (newValue) {
            _spacing = newValue
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
                    c.upper(withInset: (c.margin.up))
                } else {
                    c.putUnder(of: previous!, withOffset: previous!.margin.bottom + spacing + c.margin.up)
                }
                previous = c
//                c.leftMost()
            }
        case .bottom:
            let last = children.last
            var previous = last

            for c in Array<Control>(children.reversed()) {
                if (c === last) {
                    c.down(withInset: (c.margin.bottom))
                } else {
                    c.putAbove(Of: previous!, withOffset: previous!.margin.up + spacing + c.margin.bottom)
                }
                previous = c
//                c.leftMost()
            }
        case .atIntervals:
            let views = self.view.subviews as NSArray
            let first = children.first
            let verticalLayoutConstraints = NSLayoutConstraint.autoCreateConstraintsWithoutInstalling {
//                views.autoSetViewsDimension(.width, toSize: 60.0)
                views.autoDistributeViews(along: .vertical, alignedTo: .vertical, withFixedSpacing: spacing, insetSpacing: true, matchedSizes: true)
                first?.view.autoAlignAxis(toSuperviewAxis: .vertical)
            } as NSArray?
            verticalLayoutConstraints?.autoInstallConstraints()
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

/// <#Description#>
open class SelectButton: Container, Observable {
    private var options: [(String, Control)] = []
    private var numOfColumns = 4
    private var _spacing: CGFloat = 0
    private var _unselectedBackgroundColor = UIColor.white
    private var _selectedBackgroundColor = UIColor.blue
    private var _buttonHeight = CGFloat(30.0)
    private var _maxSelectable = 1

    /// <#Description#>
    var spacing: CGFloat {
        get {
            return _spacing
        }
        set (newValue) {
            _spacing = newValue
        }
    }
    
    var buttonHeight : CGFloat {
        get {
            return _buttonHeight
        }
        set (newValue) {
            _buttonHeight = newValue
        }
    }

    /// <#Description#>
    var unselectedBackgroundColor: UIColor {
        get {
            return _unselectedBackgroundColor
        }
        set (newValue) {
            _unselectedBackgroundColor = newValue
        }
    }

    /// <#Description#>
    var selectedBackgroundColor: UIColor {
        get {
            return _selectedBackgroundColor
        }
        set (newValue) {
            _selectedBackgroundColor = newValue
        }
    }
    
    private var observers : [Observer] = []

    func addObserver (handler : @escaping Observer) {
        observers.append(handler)
    }
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - name: <#name description#>
    ///   - v: <#v description#>
    override public init(name: String, view v: UIView) {
        super.init(name: name, view: v)
    }

    /// <#Description#>
    ///
    /// - Parameter selectable: <#selectable description#>
    func setMax(selectable: Int) {
        _maxSelectable = selectable
    }

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - code: <#code description#>
    ///   - label: <#label description#>
    func addOption(code: String, label: String, _ checked: Bool? = false) {
        let b = self.createButton(name: "selection-opt-" + code, title: label)
        options.append((code, b))
        if (checked)! {
            selected(b)
        }
        let container = self
        container +++ b
    }

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - name: <#name description#>
    ///   - title: <#title description#>
    /// - Returns: <#return value description#>
    func createButton(name: String, title: String) -> Control {
        let button = UIButton.newAutoLayout()
        button.setTitle(title, for: UIControlState.normal)
        button.setTitle("☑︎"+title, for: UIControlState.selected)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 0.4
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        let btn = Control(name: name, view: button).height(_buttonHeight)
        btn.bindEvent(.touchUpInside) {
            c in
            let before = btn.button.isSelected
            self.toggleSelect(btn)
            if btn.button.isSelected != before {
                for  obs in self.observers {
                    obs(self)
                }
            }
        }

        return btn
    }

    /// <#Description#>
    ///
    /// - Parameter btn: <#btn description#>
    func toggleSelect(_ btn: Control) {
        if _maxSelectable > 1 {
            if btn.button.isSelected {
                disselect(btn)
            } else {
                if (selectedValues.count == _maxSelectable) {
                    return
                }
                selected(btn)
            }
        } else if _maxSelectable == 1 {
            for (_, control) in options {
                if control != btn {
                    disselect(control)
                }
            }
            selected(btn)
        } else {
            // nothing to select
        }
    }

    /// <#Description#>
    ///
    /// - Parameter btn: <#btn description#>
    func disselect(_ btn: Control) {
        btn.button.isSelected = false
        btn.button.layer.borderWidth = 0.4
        btn.button.backgroundColor = _unselectedBackgroundColor
        btn.button.setTitleColor(UIColor.darkGray, for: .normal)
    
    }

    /// <#Description#>
    ///
    /// - Parameter btn: <#btn description#>
    func selected(_ btn: Control) {
        btn.button.isSelected = true
        btn.button.layer.borderWidth = 0
        btn.button.setTitleColor(UIColor.white, for: .normal)
        btn.button.backgroundColor = _selectedBackgroundColor
    }

    func selected ( code: String) {
        for (c, control) in options {
            if (c == code) {
                toggleSelect(control)
            }
        }
    }
    
    /// <#Description#>
    override func distribute () {

        if children.count == 0 {
            return
        }

        var rows: [[UIView]] = []
        var c = 0
        var row = [UIView]()

        for (_, control) in options {
            row.append(control.view)
            c += 1
            if c == numOfColumns || control == options.last?.1 {
                rows.append(row)
                c = 0
                if control != options.last?.1 {
                    row = [UIView]()
                }
            }
        }

        var prevRow = rows.first
        for views in rows {
            let first = views.first
            
            if views != rows.first! {
                let firstOfPrevRow = prevRow?.first!
                first?.autoPinEdge(.top, to: .bottom, of: firstOfPrevRow!, withOffset: spacing)
                first?.autoPinEdge(.left, to: .left, of: firstOfPrevRow!)
            } else {
                first?.autoPinEdge(toSuperviewEdge: .top, withInset: spacing)
                first?.autoPinEdge(toSuperviewEdge: .left, withInset: spacing)
            }

            let horizontalLayoutConstraints = NSLayoutConstraint.autoCreateAndInstallConstraints {
                (views as NSArray).autoDistributeViews(along: .horizontal, alignedTo: .horizontal, withFixedSpacing: spacing, insetSpacing: true, matchedSizes: true)
                } as NSArray?
            horizontalLayoutConstraints?.autoInstallConstraints()

            prevRow = views
        }
    }
    
    /// <#Description#>
    var selectedValues : [String] {
        var result = [String]()
        for (code, control) in options {
            if (control.button.isSelected) {
                result.append(code)
            }
        }
        
        return result
    }
}

open class Section: Container {
    private var _title = ""
    private var _titleControl: Control? = nil
    private var contents: [Container] = []
    private var _lineSpace: CGFloat = 1

    var lineSpace: CGFloat {
        get { return _lineSpace }
        set (v) { _lineSpace = v }
    }

    var title: String {
        get { return _title }
        set(newValue) {
            self._title = newValue
        }
    }

    var titleConrol: Control? {
        get { return _titleControl }
        set(newValue) {
            self._titleControl = newValue
        }
    }

    var titleLayoutCode: (() -> Void)?

    override func configLayout () {
        super.configLayout()
        configTitleLayout()
    }

    subscript (_ index: Int) -> Container {
        return contents[index]
    }

    var count: Int { return contents.count }

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


    override func distribute() {
        if (contents.count == 0) {
            return
        }

        let first = contents.first
        var previous = first
        for r in contents {
            if (r === first) {
                if (titleConrol != nil) {
                    r.putUnder(of: _titleControl!, withOffset: _lineSpace + r.margin.up)
                } else {
                    r.upper(withInset: r.margin.up)
                }
            } else {
                r.putUnder(of: previous!, withOffset: _lineSpace + r.margin.up)
            }
            r.leftMost(withInset: r.margin.left).rightMost(withInset: r.margin.right)
            previous = r
        }

        self.bottomAlign(with: previous!)
    }

    static func += (left: inout Section, right: Container) {
        left.append(right)
    }

    @discardableResult
    static func <<< (left: Section, right: Container) -> Section {
        var section = left
        section += right
        return left
    }

    func add(row: Row, alignment align: LeftRight = .left) {
        row.distribution = align
        append(row)
    }

    func append(_ r: Container) {
        children.append(r)
        contents.append(r)
        r.parent = self
        view.addSubview(r.view)
    }
    
    func reset() {
        for c in contents {
            c.view.removeFromSuperview()
        }
        contents.removeAll()
        children.removeAll()
    }

}

func HL (_ color: UIColor? = UIColor.black, _ width: Float? = 1) -> Container {
    let hl = UIView.newAutoLayout()
    hl.backgroundColor = color
    hl.autoSetDimension(.height, toSize: CGFloat(width!))

    return Container(name: "line", view: hl)
}

class Header: Section {
    init(_ title: String? = "") {
        super.init(name: "Header-Section", view: UIView.newAutoLayout())
        super.title = title!
        super.titleConrol = HL()
        self.view.addSubview((titleConrol?.view)!)
    }
}
