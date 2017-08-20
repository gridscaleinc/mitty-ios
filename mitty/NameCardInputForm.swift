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

class NameCardInputForm: Container {

    let myName = MQForm.text(name: "name", placeHolder: "名前入力")
    let businessName = MQForm.text(name: "businessName", placeHolder: "会社・組織名")
    let businessSubName = MQForm.text(name: "businessSubName", placeHolder: "グループ・部署など")
    let addressLine1 = MQForm.text(name: "addressLine1", placeHolder: "住所１")
    let addressLine2 = MQForm.text(name: "addressLine2", placeHolder: "住所２")
    let position = MQForm.text(name: "position", placeHolder: "タイトル")
    let phone = MQForm.text(name: "phone", placeHolder: "電話番号")
    let mobilePhone = MQForm.text(name: "mobilePhone", placeHolder: "携帯:090-33603033")
    let webpage = MQForm.text(name: "webpage", placeHolder: "http://www.abcdefg.com")
    let mailAddress = MQForm.text(name: "mailAddress", placeHolder: "xxx@abcdefg.com")
    let fax = MQForm.text(name: "fax", placeHolder: "FAX：03-092020-11")

    func load () {

        let form = self

        form +++ businessName.layout {
            b in
            b.upper(withInset: 10)
                .leftMost(withInset: 20)
                .height(30)
                .rightMost(withInset: 30)
        }
        
        form +++ webpage.layout {
            b in
            b.putUnder(of: self.businessName, withOffset: 5)
                .leftMost(withInset: 20).height(30)
                .rightMost(withInset: 30)
        }
        
        form +++ businessSubName.layout {
            b in
            b.putUnder(of: self.webpage, withOffset: 5)
                .leftMost(withInset: 20).height(30)
                .rightMost(withInset: 30)
        }

        form +++ position.layout {
            b in
            b.putUnder(of: self.businessSubName, withOffset: 5)
                .leftMost(withInset: 20).height(30)
                .rightMost(withInset: 30)
        }

        form +++ myName.layout {
            b in
            b.putUnder(of: self.position, withOffset: 5)
                .leftMost(withInset: 20).height(30)
                .rightMost(withInset: 30)
        }

        form +++ addressLine1.layout {
            b in
            b.putUnder(of: self.myName, withOffset: 5)
                .leftMost(withInset: 20).height(30)
                .rightMost(withInset: 30)
        }
        
        form +++ addressLine2.layout {
            b in
            b.putUnder(of: self.addressLine1, withOffset: 5)
                .leftMost(withInset: 20).height(30)
                .rightMost(withInset: 30)
        }

        form +++ mailAddress.layout {
            b in
            b.putUnder(of: self.addressLine2, withOffset: 5)
                .leftMost(withInset: 20).height(30)
                .rightMost(withInset: 30)
        }
        
        form +++ phone.layout {
            b in
            b.putUnder(of: self.mailAddress, withOffset: 5)
                .leftMost(withInset: 20).height(30)
                .rightMost(withInset: 30)
        }
        
        form +++ mobilePhone.layout {
            b in
            b.putUnder(of: self.phone, withOffset: 5)
                .leftMost(withInset: 20).height(30)
                .rightMost(withInset: 30)
        }
        
        form +++ fax.layout {
            b in
            b.putUnder(of: self.mobilePhone, withOffset: 5)
                .leftMost(withInset: 20).height(30)
                .rightMost(withInset: 30)
        }
    }
}
