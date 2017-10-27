//
//  DashBoardForm.swift
//  mitty
//
//  Created by gridscale on 2017/10/19.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UICircularProgressRing

class DashBoardForm : Container {
    let instandSpeed = DashBoardForm.speedoMeter(120, 320)
    let averageSpeed = DashBoardForm.speedoMeter(150, 390)
    
    func loadForm () {
        self.view.backgroundColor = UIColor(white: 0.02, alpha: 0.8)

        self +++ instandSpeed.layout {
            l in
            l.verticalCenter().leftMost(withInset: 10).width(100).height(100)
        }
        self +++ MQForm.label(name: "instand", title: "Speed").layout {
            l in
            l.label.textColor = .white
            l.label.textAlignment = .center
            l.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            l.height(30).width(100).putAbove(of: self.instandSpeed, withOffset: -45).leftAlign(with: self.instandSpeed)
        }
        
        self +++ averageSpeed.layout {
            l in
            l.verticalCenter().righter(than: self.instandSpeed, withOffset: -10).width(130).height(130)
        }
        self +++ MQForm.label(name: "average", title: "Average").layout {
            l in
            l.label.textColor = .white
            l.label.textAlignment = .center
            l.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            l.height(30).width(130).putAbove(of: self.averageSpeed, withOffset: -55).leftAlign(with: self.averageSpeed)
        }
        
        let timeView = TimeDisplayView.newAutoLayout()
        let timeClock = Control(name:"time", view: timeView).layout {
            time in
            time.width(80).height(80).verticalCenter().rightMost(withInset: 10)
//            time.view.layer.borderColor = MittyColor.white.cgColor
//            time.view.layer.borderWidth = 1
        }
        
        self +++ timeClock
        
        let layer = MittyColor.gradientLayer(.black, MittyColor.healthyGreen.withAlphaComponent(0.5), UIColor.black.withAlphaComponent(0.5))
        layer.frame = CGRect(x: 0, y: 0, width: 400, height: 250)
        self.view.layer.insertSublayer(layer, at: 0)
    }
    
    func updateInstantSpeed (_ v: Double) {
        updateSpeed(instandSpeed, v)
    }
    
    func updateAverageSpeed(_ v: Double) {
        updateSpeed(averageSpeed, v)
    }
    
    func updateSpeed(_ s: Control, _ v: Double) {
        
        let circular = s.view as! UICircularProgressRingView
        let velocity = (v * 3.6 < 180) ? v*3.6 : 180
        let speed = (velocity < 300) ? CGFloat(velocity) : 180
        
        circular.setProgress(value: speed, animationDuration: 1)
    }
    
    static func speedoMeter (_ startAngel: Int, _ endAngle: Int) -> Control {
        let speedProgress : Control = {
            let p = UICircularProgressRingView.newAutoLayout()
            p.outerRingColor = MittyColor.white.withAlphaComponent(0.8)
//             p.ringStyle = .ontop
            p.ringStyle = .dotted
            p.outerRingWidth = 3
            p.maxValue = 250
            p.startAngle = CGFloat(startAngel)
            p.endAngle = CGFloat(endAngle)
            p.fullCircle = false
            p.innerCapStyle = .square
            p.fontColor = MittyColor.white
            p.font = UIFont.boldSystemFont(ofSize: 15)
            p.innerRingWidth = 5
            p.innerRingSpacing = 1
            p.innerRingColor = MittyColor.red
            p.valueIndicator = "km/h"
            p.setProgress(value: 50, animationDuration: 3)
            p.font = UIFont.systemFont(ofSize: 18)
            return Control(name:"speedCircle", view: p)
        }()
        
        return speedProgress
    }
}
