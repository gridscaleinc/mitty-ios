//
//  LockForm.swift
//  mitty
//
//  Created by gridscale on 2017/09/21.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

class LockForm :MQForm {
    
    
    
    let unlockButton = MQForm.button(name: "unlock", title: "Unlock")
    
    func load () {
        
        self +++ unlockButton.layout {
            b in
            b.down(withInset: 120).holizontalCenter().width(90).height(40)
            b.button.backgroundColor = MittyColor.healthyGreen
        }
//        unlockButton.configLayout()
        self.autoPinEdgesToSuperviewEdges()
        self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
    
}
