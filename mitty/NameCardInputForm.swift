//
//  NameCardInputForm.swift
//  mitty
//
//  Created by gridscale on 2017/08/13.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

class NameCardInputForm: MQForm {

    let myName = MQForm.text(name: "name", placeHolder: "名前")
    let businessName = MQForm.text(name: "company", placeHolder: "組織・会社名")
    let addressLine1 = MQForm.text(name: "address1", placeHolder: "〒・住所１")
    let addressLine2 = MQForm.text(name: "address2", placeHolder: "住所２")
    let position = MQForm.text(name: "position", placeHolder: "役職・職務")
    let phone = MQForm.text(name: "Phone", placeHolder: "携帯： 090-5309-0092")
    let webpage = MQForm.text(name: "webpage", placeHolder: "http://localhost.com")
    let mailAddress = MQForm.text(name: "mailAddress", placeHolder: "abc@localhost.com")
    let fax = MQForm.text(name: "fax", placeHolder: "fax: 03-0102-1201")

    func load () {

        let form = self

        form +++ businessName.layout {
            b in
            b.upper(withInset: 10).leftMost(withInset: 20).height(30)
            b.textField.font = UIFont.boldSystemFont(ofSize: 18)
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
            b.textField.font = UIFont.boldSystemFont(ofSize: 12)
            b.textField.textColor = UIColor(white: 0.5, alpha: 1)
        }


        form +++ position.layout {
            b in
            b.putUnder(of: self.addressLine2, withOffset: 10).leftMost(withInset: 80).height(30)
            b.textField.font = UIFont.boldSystemFont(ofSize: 14)
            b.textField.textColor = UIColor(white: 0.5, alpha: 1)
        }

        form +++ myName.layout {
            b in
            b.putUnder(of: self.position, withOffset: 5).leftMost(withInset: 80).height(30)
            b.textField.font = UIFont.boldSystemFont(ofSize: 25)
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
            b.textField.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            b.textField.textColor = MittyColor.healthyGreen
        }

        form +++ mailAddress.layout {
            b in
            b.putUnder(of: self.webpage, withOffset: 3).leftMost(withInset: 20).height(15)
            b.textField.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            b.textField.textColor = MittyColor.healthyGreen
        }
        form +++ phone.layout {
            b in
            b.putUnder(of: self.mailAddress, withOffset: 3).leftMost(withInset: 20).height(15)
            b.textField.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            b.textField.textColor = MittyColor.healthyGreen
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
