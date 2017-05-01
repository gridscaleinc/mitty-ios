//
//  MittyStyle.swift
//  mitty
//
//  Created by gridscale on 2017/04/30.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

class MittyColor {
    
    static let background = UIColor.white
    static let title = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
    static let buttonNormal = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0)
    static let buttonNegative = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
    static let buttonAlert = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0)
    
    static let baseYellow = UIColor(red: 1.0, green: 1.0, blue: 0.6, alpha: 1.0)
    static let healthyGreen = UIColor(red: 72/255, green: 201/255, blue: 176/255, alpha:1.0)
    
    static func gradientLayer() -> CAGradientLayer {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [
            UIColor.orange.cgColor,
            UIColor.orange.cgColor
        ]
        
        gradientLayer.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 0, 1)
        
        return gradientLayer
    }
}
