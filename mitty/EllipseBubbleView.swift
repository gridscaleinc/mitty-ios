//
//  EllipseBubbleView.swift
//  mitty
//
//  Created by gridscale on 2017/11/12.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//
import UIKit
import Foundation

class EllipseLayer: CALayer  {
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(in ctx: CGContext) {
        
//        super.draw(in: ctx)
        self.backgroundColor = UIColor.clear.cgColor
        let rect: CGRect = CGRect(origin: super.frame.origin, size: CGSize(width: super.frame.width * 1.414 + 40 , height: super.frame.height * 1.414 + 40))
        
        UIGraphicsPushContext(ctx)

        UIColor.clear.setFill()
        ctx.fill(rect)
        // 三角形 -------------------------------------
        // UIBezierPath のインスタンス生成
        let path = UIBezierPath();
        
        let a = Double(rect.width / 2.0) - 20.0
        let b = Double(rect.height / 2.0) - 20
        
        // 起点
        path.move(to: CGPoint(x: Double(rect.width / 2.0) + a, y: Double(rect.height / 2.0)));
        let radian = Double.pi / 180.0
        for i in 1 ... 85 {
            let px = Double(rect.width / 2.0) + a*cos(Double(i)*radian)
            let py = Double(rect.height / 2.0) + b*sin(Double(i)*radian)
            path.addLine(to: CGPoint(x:px, y: py))
        }
        
        path.addLine(to: CGPoint(x:Double(rect.width / 2.0), y: Double(rect.height)))
        
        for i in 95 ... 360 {
            let px = Double(rect.width / 2.0) + a*cos(Double(i)*radian)
            let py = Double(rect.height / 2.0) + b*sin(Double(i)*radian)
            path.addLine(to: CGPoint(x:px, y: py))
        }
        
        // ラインを結ぶ
        path.close()
        // 色の設定
        UIColor.red.setStroke()
        // ライン幅
        path.lineWidth = 2
        // 描画
        path.stroke();
        path.move(to: CGPoint(x: Double(rect.width / 2.0), y: Double(rect.height / 2.0)));
        UIColor.orange.withAlphaComponent(0.6).setFill()
        path.fill()
    }
}
