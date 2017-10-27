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
        
        self.view.backgroundColor = UIColor(white: 0.02, alpha: 0.8)
        
        self +++ MQForm.tapableImg(name: "down-arrow", url: "downarrow").layout {
            arrow in
            arrow.upper().holizontalCenter().width(40).height(30)
            }.bindEvent(.touchUpInside) { _ in
                self.view.isHidden = true
                self.onClosed()
        }
        
        let layer = MittyColor.gradientLayer(.black, MittyColor.healthyGreen.withAlphaComponent(0.5), UIColor.black.withAlphaComponent(0.5))
        layer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height)
        self.view.layer.insertSublayer(layer, at: 0)
    }
    
    var onClosed : ()->Void = {
        
    }
}
