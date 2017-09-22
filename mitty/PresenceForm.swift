//
//  PresenceForm.swift
//  mitty
//
//  Created by gridscale on 2017/05/28.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

class PresenceForm: MQForm {
    
    let mittyId = MQForm.label(name: "mittyId", title: "")
    let nameLabel = MQForm.label(name: "name", title: "")
    
    func load () {
        
        let form = self
        
        form +++ mittyId.layout {
            b in
            b.upper(withInset: 10).leftMost(withInset: 20).height(30)
            b.label.font = UIFont.boldSystemFont(ofSize: 15)
            b.label.textColor = MittyColor.healthyGreen
        }
        
        form +++ nameLabel.layout {
            b in
            b.putUnder(of: self.mittyId).leftMost(withInset: 20).height(20)
            b.label.font = UIFont.boldSystemFont(ofSize: 15)
            b.label.textColor = MittyColor.healthyGreen
        }
    }
    
    func name(_ s: String) {
        nameLabel.label.text = "名前：" + s
    }
    
    func id(_ id: String) {
        mittyId.label.text = "MittyID：" + id
    }
}
