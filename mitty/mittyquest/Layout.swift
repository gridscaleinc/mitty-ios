//
//  Layout.swift
//  mitty
//
//  Created by gridscale on 2017/03/04.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import PureLayout

enum LeftRight {
    case leftAligned
    case rightAligned
    case centerAligned
}

enum UpBottom {
    case up
    case center
    case bottom
}


// The extension using PureLayout to layout forms
// Layout related extensions
extension Control {
    
    // set the height dimension
    @discardableResult
    open func height(_ height: CGFloat) -> Self {
        self.view.autoSetDimension(.height, toSize: height)
        return self
    }
    
    // set the width dimension
    @discardableResult
    open func width(_ width: CGFloat) -> Self {
        self.view.autoSetDimension(.width, toSize: width)
        return self
    }
    
    // set the dimensions called once
    @discardableResult
    open func size (w: CGFloat, h: CGFloat) -> Self {
        return self.width(w)
            .height(h)
    }
    
    // top alignment
    //
    @discardableResult
    open func topAlign(with control: Control, withOffset points: CGFloat? = 0) -> Self {
        self.view.autoPinEdge(.top, to: .top, of: control.view, withOffset: points!)
        return self
    }
    
    // bottom alignment
    @discardableResult
    open func bottomAlign(with control: Control, withOffset points: CGFloat? = 0) -> Self {
        self.view.autoPinEdge(.bottom, to: .bottom, of: control.view, withOffset: points!)
        return self
    }
    
    // left alignment
    @discardableResult
    open func leftAlign(with control: Control, withOffset points: CGFloat? = 0 ) -> Self {
        self.view.autoPinEdge(.left, to: .left, of: control.view, withOffset: points!)
        return self
    }
    
    // right aligment
    @discardableResult
    open func rightAlign(with control: Control, withOffset points: CGFloat? = 0 ) -> Self {
        self.view.autoPinEdge(.right, to: .right, of: control.view, withOffset: points!)
        return self
    }
    
    // put a little bit above
    @discardableResult
    open func putAbove(Of control: Control, withOffset points: CGFloat? = 0 ) -> Self {
        self.view.autoPinEdge(.bottom, to: .top, of: control.view, withOffset: -points!)
        return self
    }
    
    // put a little bit under
    @discardableResult
    open func putUnder(of control: Control, withOffset points: CGFloat? = 0 ) -> Self {
        self.view.autoPinEdge(.top, to: .bottom, of: control.view, withOffset: points!)
        return self
    }
    
    // put a little lefter than
    @discardableResult
    open func lefter(than control: Control, withOffset points: CGFloat? = 0 ) -> Self {
        self.view.autoPinEdge(.right, to: .left, of: control.view, withOffset: -points!)
        return self
    }
    
    // put a litter righter
    @discardableResult
    open func righter(than control: Control, withOffset points: CGFloat? = 0 ) -> Self {
        self.view.autoPinEdge(.left, to: .right, of: control.view, withOffset: points!)
        return self
    }
    
    // top alignment, put lefter
    @discardableResult
    open func topAlign(lefterThan control: Control, withOffset points: (lower: CGFloat, spacing:CGFloat)?=(0,0)) -> Self {
        return self.topAlign(with:control, withOffset: points?.lower)
            .lefter(than: control, withOffset: points?.spacing)
    }
    
    // top alignment, put righter
    @discardableResult
    open func topAlign(righterThan control: Control, withOffset points: (lower: CGFloat, spacing:CGFloat)?=(0,0)) -> Self {
        return self.topAlign(with:control, withOffset: points?.lower)
            .righter(than: control, withOffset: points?.spacing)
    }
    
    // bottom alignment, put lefter
    @discardableResult
    open func bottomLefter(aignWith control: Control, withOffset points: (higher: CGFloat, spacing:CGFloat)?=(0,0)) -> Self {
        return self.bottomAlign(with: control, withOffset: points?.higher)
            .lefter(than: control, withOffset: points?.spacing)
    }
    
    // bottom alignment, put righter
    @discardableResult
    open func bottomRighter(to control: Control, withOffset points: (higher: CGFloat, spacing:CGFloat)?=(0,0)) -> Self {
        return self
            .bottomAlign(with:control, withOffset: points?.higher)
            .righter(than: control, withOffset: points?.spacing)
    }

    // upper down left righ to super view
    // using purelayout
    //
    // upper
    @discardableResult
    open func upper(withInset inset: CGFloat? = 0) -> Self {
        self.view.autoPinEdge(toSuperviewEdge: .top, withInset: inset!)
        return self
    }
    
    // down
    @discardableResult
    open func down(withInset inset: CGFloat? = 0) -> Self {
        self.view.autoPinEdge(toSuperviewEdge: .bottom, withInset: inset!)
        return self
    }
    // left, right
    @discardableResult
    open func leftMost(withInset inset: CGFloat? = 0) -> Self {
        self.view.autoPinEdge(toSuperviewEdge: .left, withInset: inset!)
        return self
    }
    
    @discardableResult
    open func rightMost(withInset inset: CGFloat? = 0) -> Self {
        self.view.autoPinEdge(toSuperviewEdge: .right, withInset: inset!)
        return self
    }
    
    // center
    
    // margin serials 
    @discardableResult
    open func leftMargin(_ m: CGFloat) -> Self {
        self.margin.left = m
        return self
    }
    
    @discardableResult
    open func rightMargin(_ m: CGFloat) -> Self {
        self.margin.right = m
        return self
    }
    
    @discardableResult
    open func upMargin(_ m: CGFloat) -> Self {
        self.margin.up = m
        return self
    }
    
    @discardableResult
    open func bottomMargin(_ m: CGFloat) -> Self {
        self.margin.bottom = m
        return self
    }
    
}

public struct ControlMargin {
    var _left: CGFloat = 0
    var _right: CGFloat = 0
    var _up: CGFloat = 0
    var _bottom: CGFloat = 0
    
    var left: CGFloat {
        get {return _left}
        set (v) {
            _left = v
        }
    }

    var right: CGFloat {
        get {return _right}
        set (v) {
            _right = v
        }
    }
    
    var up: CGFloat {
        get {return _up}
        set (v) {
            _up = v
        }
    }
    var bottom: CGFloat {
        get {return _bottom}
        set (v) {
            _bottom = v
        }
    }
    
    init (l: CGFloat?=0, r: CGFloat?=0 , u: CGFloat?=0, b: CGFloat?=0) {
        _left = l!
        _right = r!
        _up = u!
        _bottom = b!
    }
    
}
