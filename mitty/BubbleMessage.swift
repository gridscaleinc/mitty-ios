//
//  BubbleMessage.swift
//  mitty
//
//  Created by gridscale on 2017/10/23.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

class BubbleMessage : Section, CAAnimationDelegate {
    let bornDateTime = Date()
    let msgLabel = MQForm.label(name:"message", title:"")
    let img = MQForm.img(name: "aaa", url: "pengin4")
    
    var left : CGFloat {
        if vc == nil {
            return 0
        }
        return (UIScreen.main.bounds.width / 2) + CGFloat(10*sin(bornDateTime.timeIntervalSinceNow))
    }
    
    var top : CGFloat {
        if vc == nil {
            return 0
        }
        return UIScreen.main.bounds.height + CGFloat(bornDateTime.timeIntervalSinceNow)
    }
    
    var w : CGFloat {
        if vc == nil {
            return 0
        }
        return CGFloat(2*(bornDateTime.timeIntervalSinceNow * -1))
    }
    
    var h : CGFloat {
        if vc == nil {
            return 0
        }
        return CGFloat(2*(bornDateTime.timeIntervalSinceNow * -1))
    }
    
    var timer = Timer()
    weak var vc: UIViewController!
    
    
    ///
    /// バブルを放す
    ///
    /// - Parameters:
    ///   - vc: viewController
    ///   - msg: メッセージ
    func release(vc: UIViewController, msg: String) {
        self.vc = vc
        
        let row = Row.LeftAligned()
        row +++ img.layout {
            l in
            l.width(25).height(25).leftMost(withInset: 5).verticalCenter().leftMargin(10)
        }
        
        self <<< row
        
        msgLabel.label.text = msg
        row +++ msgLabel.layout{
            l in
            l.label.textColor = MittyColor.darkText
            l.rightMost(withInset: 5).verticalCenter().taller(than: 40).leftMargin(5)
            l.label.numberOfLines = 0
            l.label.adjustsFontSizeToFitWidth = true
        }
        
        row.layout {
            s in
            s.bottomAlign(with: self.msgLabel).fillHolizon().topAlign(with: self.msgLabel)
        }
        self.layout {
            s in
            s.width(200)
        }
        
        self.configLayout()
        rising()
        
    }
    
    private var fallingDuration: TimeInterval = 4
    private let animationKey = "fallingAnimation"
    
    func rising(delayDouble: Double = 0.5) {
        // scale
        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        scaleAnimation.duration = fallingDuration
        scaleAnimation.repeatCount = Float.infinity
        
        let transform = CATransform3DIdentity
        let transformScale = CATransform3DScale(transform, 2, 2.5, 1.0);

        scaleAnimation.toValue = NSValue(caTransform3D : transformScale)
        
        // 移動
        let startPoint = CGPoint(x:UIScreen.main.bounds.width/2, y:UIScreen.main.bounds.height)
        let endPoint = CGPoint(x:UIScreen.main.bounds.width/2, y:0)
        let moveAnimation = CABasicAnimation(keyPath: "position")
        moveAnimation.duration = fallingDuration
        moveAnimation.fromValue = NSValue(cgPoint: startPoint)
        moveAnimation.toValue = NSValue(cgPoint: endPoint)
        
        // zPosition(最前面に表示し続けるための処理)
        let zAnimation = CABasicAnimation(keyPath: "transform.translation.z")
        zAnimation.fromValue = self.view.layer.bounds.size.width
        zAnimation.repeatCount = Float.infinity
        zAnimation.toValue = zAnimation.fromValue
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = fallingDuration
        animationGroup.repeatCount = 1
        animationGroup.animations = [scaleAnimation, moveAnimation]
        animationGroup.delegate = self
        
        self.view.layer.add(animationGroup, forKey: self.animationKey)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.view.removeFromSuperview()
        }
    }
}
