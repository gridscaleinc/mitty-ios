//
//  BubbleMessage.swift
//  mitty
//
//  Created by gridscale on 2017/10/23.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

class BubbleMessage : Container, CAAnimationDelegate {
    var count = 15
    let bornDateTime = Date()
    let msgLabel = MQForm.label(name:"message", title:"")
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
        let img = MQForm.img(name: "aaa", url: "pengin4").layout {
            l in
            l.width(30).height(30).leftMost(withInset: 1).verticalCenter()
        }
        self +++ img
        
        msgLabel.label.text = msg
        self +++ msgLabel.layout{
            l in
            l.label.textColor = MittyColor.sunshineRed
            l.righter(than: img, withOffset: 2).fillVertical(3).rightMost(withInset: 5)
            l.label.numberOfLines = 0
            l.label.adjustsFontSizeToFitWidth = true
        }
        
        self.layout {
            s in
            s.bottomAlign(with: self.msgLabel).width(200).taller(than: 50)
        }
        
        self.configLayout()
        falling()
        
    }
    
    private var fallingDuration: TimeInterval = 5
    private let animationKey = "fallingAnimation"
    
    func falling(delayDouble: Double = 0.5) {
        // 回転
        let rotateAnimation = CABasicAnimation(keyPath: "transform")
        rotateAnimation.duration = 0.3
        rotateAnimation.repeatCount = Float.infinity
        let transform = CATransform3DMakeRotation(CGFloat.pi,  0, 1.0, 0)
        rotateAnimation.toValue = NSValue(caTransform3D : transform)
        
        // 移動
        let startPoint = CGPoint(x:UIScreen.main.bounds.width/2, y:0)
        let endPoint = CGPoint(x:UIScreen.main.bounds.width/2, y:UIScreen.main.bounds.height)
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
        animationGroup.animations = [moveAnimation]
        animationGroup.delegate = self
        
        self.view.layer.add(animationGroup, forKey: self.animationKey)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.view.removeFromSuperview()
        }
    }
}
