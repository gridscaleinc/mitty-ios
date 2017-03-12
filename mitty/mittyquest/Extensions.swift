//
//  Extensions.swift
//  mitty
//
//  Created by gridscale on 2017/03/01.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    @discardableResult
    func addControl(_ control: Control2) -> Self {
        self.addSubview(control.field)
        return self
    }
    
    // assignment
    static func += (left : inout UIView, right: Control2) {
        left.addControl(right)
    }
    
}
