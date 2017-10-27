//
//  ControlPanel.swift
//  mitty
//
//  Created by gridscale on 2017/10/26.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//


import Foundation
import UIKit

class ControlPanel : Section {
    
    var height = CGFloat(500)
    
    init(h: CGFloat) {
        super.init(name:"controlPanel", view: UIView.newAutoLayout())
        height = h
        loadForm()
    }
    
    func loadForm () {
        
        self.view.backgroundColor = MittyColor.greenGrass.withAlphaComponent(0.9)
        
        self +++ MQForm.tapableImg(name: "down-arrow", url: "downarrow").layout {
            arrow in
            arrow.upper().holizontalCenter().width(40).height(30)
            }.bindEvent(.touchUpInside) { _ in
                self.view.isHidden = true
                self.onClosed()
        }
        
    }
    
    var onClosed : ()->Void = {
        
    }
}
