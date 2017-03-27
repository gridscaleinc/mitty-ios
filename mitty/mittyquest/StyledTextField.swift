//
//  StyledTextField.swift
//  mitty
//
//  Created by gridscale on 2017/03/25.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

class StyledTextField : UITextField {
    var hairlineLayer : CALayer = CALayer()

    var hilightedLineColor = UIColor.red.cgColor
    
    var lineWidth : CGFloat = 1.2
    
    override func layoutSubviews () {
        super.layoutSubviews()
        
        
        self.hairlineLayer.backgroundColor = UIColor.blue.cgColor
        self.layer.addSublayer(self.hairlineLayer)
    
        var hairlineHeight:CGFloat = 0.0;
        if (self.isFirstResponder) {
            self.hairlineLayer.backgroundColor = UIColor.blue.cgColor
            hairlineHeight = lineWidth
        } else {
            self.hairlineLayer.backgroundColor = UIColor.gray.cgColor
            hairlineHeight = CGFloat(1).divided(by: UIScreen.main.scale)
        }
        
        self.hairlineLayer.frame = CGRect(x:0, y: self.bounds.height.subtracting(hairlineHeight)
            , width:self.bounds.width, height:hairlineHeight)
    }
}
