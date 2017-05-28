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
            b.upper(withInset: 10).leftMost(withInset: 20).height(30)
            b.label.font = UIFont.boldSystemFont(ofSize: 18)
        }
        
        form +++ addressLine1.layout {
            b in
            b.putUnder(of: self.businessName).leftMost(withInset: 20).height(20)
            b.label.font = UIFont.boldSystemFont(ofSize: 12)
            b.label.textColor = UIColor(white: 0.5, alpha: 1)
        }
        
        form +++ addressLine2.layout {
            b in
            b.putUnder(of: self.addressLine1).leftMost(withInset: 20).height(20)
            b.label.font = UIFont.boldSystemFont(ofSize: 12)
            b.label.textColor = UIColor(white: 0.5, alpha: 1)
        }
        

        form +++ position.layout {
            b in
            b.putUnder(of: self.addressLine2, withOffset: 10).leftMost(withInset: 80).height(30)
            b.label.font = UIFont.boldSystemFont(ofSize: 14)
            b.label.textColor = UIColor(white: 0.5, alpha: 1)
        }
        
        form +++ myName.layout {
            b in
            b.putUnder(of: self.position, withOffset: 5).leftMost(withInset: 80).height(30)
            b.label.font = UIFont.boldSystemFont(ofSize: 25)
        }
        
        let row = Row.LeftAligned().layout() {
            r in
            
            r.height(5).fillHolizon(0).putUnder(of: self.myName, withOffset: 10)
            let layer = MittyColor.gradientLayer()
            layer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 25, height: 2)
            r.view.layer.insertSublayer(layer, at: 0)
        }
        
        form +++ row
        
        form +++ webpage.layout {
            b in
            b.putUnder(of: self.myName, withOffset: 15).leftMost(withInset: 20).height(15)
            b.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            b.label.textColor = MittyColor.healthyGreen
        }
        
        form +++ mailAddress.layout {
            b in
            b.putUnder(of: self.webpage, withOffset: 3).leftMost(withInset: 20).height(15)
            b.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            b.label.textColor = MittyColor.healthyGreen
        }
        form +++ phone.layout {
            b in
            b.putUnder(of: self.mailAddress, withOffset: 3).leftMost(withInset: 20).height(15)
            b.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            b.label.textColor = MittyColor.healthyGreen
        }
        
        form.layer.masksToBounds = true
        form.layer.backgroundColor = UIColor(white: 0.94, alpha: 1).cgColor
        form.layer.borderColor = UIColor.gray.cgColor
        // form.layer.borderWidth = 0.5
        form.layer.shadowColor = UIColor.black.cgColor
        form.layer.shadowOffset = CGSize(width: -10, height: 10)
        form.layer.shadowOpacity = 0.8
        form.layer.shadowRadius = 1.8
        
        
    }
}
