//
//  NameCard.swift
//  mitty
//
//  Created by gridscale on 2017/05/28.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

class NameCardForm : MQForm {
    
    
    let myName = MQForm.label(name: "name", title: "黄　永紅")
    let businessName = MQForm.label(name: "name", title: "株式会社　ABC")
    let addressLine1 = MQForm.label(name: "address1", title: "東京都品川区南品川")
    let addressLine2 = MQForm.label(name: "address2", title: "4-980-1029")
    let position = MQForm.label(name: "position", title: "代表取締役社長")
    let phone = MQForm.label(name: "Phone", title: "携帯： 090-5309-0092")
    let webpage = MQForm.label(name: "webpage", title: "http://localhost.com")
    let mailAddress = MQForm.label(name: "mailAddress", title: "abc@localhost.com")
    let fax = MQForm.label(name: "fax", title: "fax: 03-0102-1201")
    
    func load () {
        
        let form = self
        
        form +++ businessName.layout {
            b in
            b.upper(withInset: 30).leftMost(withInset: 20).height(40)
            b.label.font = UIFont.boldSystemFont(ofSize: 18)
        }
        
        form +++ addressLine1.layout {
            b in
            b.putUnder(of: self.businessName).leftMost(withInset: 20).height(30)
            b.label.font = UIFont.boldSystemFont(ofSize: 12)
        }
        
        form +++ addressLine2.layout {
            b in
            b.putUnder(of: self.addressLine1).leftMost(withInset: 20).height(30)
            b.label.font = UIFont.boldSystemFont(ofSize: 12)
        }
        
        
        form +++ position.layout {
            b in
            b.putUnder(of: self.addressLine2, withOffset: 40).leftMost(withInset: 50).height(50)
            b.label.font = UIFont.boldSystemFont(ofSize: 14)
        }
        
        form +++ myName.layout {
            b in
            b.putUnder(of: self.position, withOffset: 5).leftMost(withInset: 50).height(50)
            b.label.font = UIFont.boldSystemFont(ofSize: 20)
        }
        
        form.backgroundColor = UIColor.blue.withAlphaComponent(0.4)
        form.layer.shadowColor = UIColor.gray.cgColor
        form.layer.shadowOffset = CGSize(width:2, height:2)
        
    }
}
