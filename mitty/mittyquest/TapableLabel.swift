//
//  TapableLabel.swift
//  mitty
//
//  Created by gridscale on 2017/03/20.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

class TapableLabel : UILabel {
    
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

        if self.point(inside: point, with: event) {
            return self
        } else {
            return nil
        }
    }
}
