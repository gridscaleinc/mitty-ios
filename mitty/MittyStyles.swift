//
//  MittyStyles.swift
//  mitty
//
//  Created by gridscale on 2016/11/13.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

// use case
// UIButton.backgroundColor = MittyStyle.button.update.color

class MittyStyles {
    static let button = initButtonStyles()
    static let label = initLabelStyles()
    
    static func initButtonStyles() {
        
    }
    
    static func initLabelStyles() {
        
    }
}


class StyleContext {
    var button : StyleSet = {
        return StyleSet()
    } ()
    
    
    var label : StyleSet = {
         return StyleSet()
    } ()
    
    var view : StyleSet = {
         return StyleSet()
    } ()
    
    var dialogue : StyleSet = {
         return StyleSet()
    } ()

}

class StyleSet {
    var update : Style = {
        return Style()
    } ()
    
    var normal : Style = {
        return Style()
    } ()

    var negtive : Style = {
        return Style()
    } ()

    var active : Style = {
        return Style()
    } ()
    
    var disabled : Style = {
        return Style()
    } ()

}


class Style {
    
    // text Color
    var color : UIColor?
    
    // background color
    var backgroundColor : UIColor?
    
    //
    var borderWidth : Int?
    
    //
    var borderColor : UIColor?
    
    //
    var font : UIFont?
    
    //
    var inset : Int?
    
}

/// Swiftの色クラスを拡張する
/// 色を構築する便利なメソッドを追加
/// 具体的な色はColorPalelteクラスを参照。
extension UIColor {
    
    // alpha指定のRGB色を構築
    static func rgb(value: UInt, alpha: CFloat? ) -> UIColor {
        let a = alpha ?? 1.0
        
        return UIColor(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: CGFloat(a)
        )
    }
    
    // alpha = 1.0 のRGB色を構築
    static func rgb(value: UInt) -> UIColor {
        return rgb(value: value, alpha: 1.0)
    }
}
