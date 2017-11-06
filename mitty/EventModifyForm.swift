//
//  EventModifyForm.swift
//  mitty
//
//  Created by gridscale on 2017/11/06.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

import UIKit
import PureLayout

//
//
//
class EventModifyForm: EventEditForm {
    
    // ボタンなど、アクション必要なコントロールはインスタンスメンバーを定義し、
    // viewを直で取得できるComputedPropertyを用意
    let modifyButton = MQForm.button(name: "modify", title: "保存する")
    
    //　項目単位の小さいロジックはForm中で実装して良い。
    
    override  func setButtons(_ form: Section) {
        
        let row = Row.Intervaled().layout() {
            r in
            r.height(55).fillHolizon()
        }
        row.spacing = 60
        
        row +++ modifyButton.width(60).height(50).layout() {
            c in
            c.button.backgroundColor = MittyColor.white
            c.button.setTitleColor(MittyColor.sunshineRed, for: .normal)
        }
        
        form <<< row
        
    }
    
}

