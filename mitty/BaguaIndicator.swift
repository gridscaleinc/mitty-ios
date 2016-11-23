//
//  BaiguaIndicator.swift
//  TestIndicator
//
//  Created by gridscale on 2016/11/22.
//  Copyright © 2016年 gridscale. All rights reserved.
//

import Foundation
import UIKit

class BaguaIndicator : UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.animationImages = [
            UIImage(named: "bagua_1")!,
            UIImage(named: "bagua_2")!,
            UIImage(named: "bagua_3")!,
            UIImage(named: "bagua_4")!,
            UIImage(named: "bagua_5")!,
            UIImage(named: "bagua_6")!,
            UIImage(named: "bagua_7")!,
            UIImage(named: "bagua_8")!
        ]
        
        self.animationDuration = 4

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
