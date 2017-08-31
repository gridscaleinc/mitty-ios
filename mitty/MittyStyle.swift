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
    static let pink = UIColor(red: 1.0, green: 110.0/255, blue: 199/255, alpha: 1.0)
    
    static let healthyGreen = UIColor.colorWithRGB(rgbValue: 0x1ABC9C)
    static let lightYellow = UIColor(red: 250/255, green: 215/255, blue: 160/255, alpha:1.0)
    static let light = UIColor(white:0.98, alpha:1.0)

    
    
    static func gradientLayer(_ s: UIColor? = UIColor.orange, _ m: UIColor? = UIColor.orange, _ e: UIColor? = UIColor.orange) -> CAGradientLayer {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [
            s!.cgColor,
            m!.cgColor,
            e!.cgColor
        ]
        
        gradientLayer.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 0, 1)
        
        return gradientLayer
    }
}

/**
 UIColor extension that add a whole bunch of utility functions like:
 - HTML/CSS RGB format conversion (i.e. 0x124672)
 - lighter color
 - darker color
 - color with modified brightness
 */
extension UIColor {
    /**
     Construct a UIColor using an HTML/CSS RGB formatted value and an alpha value
     
     :param: rgbValue RGB value
     :param: alpha color alpha value
     
     :returns: an UIColor instance that represent the required color
     */
    class func colorWithRGB(rgbValue : UInt, alpha : CGFloat = 1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255
        let green = CGFloat((rgbValue & 0xFF00) >> 8) / 255
        let blue = CGFloat(rgbValue & 0xFF) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
     Returns a lighter color by the provided percentage
     
     :param: lighting percent percentage
     :returns: lighter UIColor
     */
    func lighterColor(percent : Double) -> UIColor {
        return colorWithBrightnessFactor(factor: CGFloat(1 + percent));
    }
    
    /**
     Returns a darker color by the provided percentage
     
     :param: darking percent percentage
     :returns: darker UIColor
     */
    func darkerColor(percent : Double) -> UIColor {
        return colorWithBrightnessFactor(factor: CGFloat(1 - percent));
    }
    
    /**
     Return a modified color using the brightness factor provided
     
     :param: factor brightness factor
     :returns: modified color
     */
    func colorWithBrightnessFactor(factor: CGFloat) -> UIColor {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * factor, alpha: alpha)
        } else {
            return self;
        }
    }
}

extension CGSize {
    var ratio : CGFloat {
        if self.width == 0 || self.height == 0 {
            return -1
        }
        
        return self.height / self.width
    }
}

extension UIView {
    func blink(duration: TimeInterval? = 1, delay: TimeInterval? = 0) {
        var count = 5
        
        UIView.animate(withDuration: duration!, //Time duration you want,
            delay: delay!,
            options: [.curveEaseOut, .autoreverse, .repeat],
            animations: { [weak self] in self?.alpha = 0.0 },
            completion: { [weak self] _ in
                self?.alpha = 1.0
                count -= 1
                if count == 0 {
                    self?.layer.removeAllAnimations()
                }
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.layer.removeAllAnimations()
        }
    }
    
    // TODO REMOVE ANIMATIOS
}

