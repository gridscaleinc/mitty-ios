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

class NameCardForm: Container {


    let myName = MQForm.label(name: "name", title: "黄　永紅")
    let businessName = MQForm.label(name: "businessName", title: "株式会社　ABC")
    let businessLogo = MQForm.img(name: "businessLogo", url: "timesquare")
    let businessSubName = MQForm.label(name: "businessSubName", title: "システム開発部")
    let addressLine1 = MQForm.label(name: "addressLine1", title: "東京都品川区南品川")
    let addressLine2 = MQForm.label(name: "addressLine2", title: "4-980-1029")
    let businessTitle = MQForm.label(name: "businessTitle", title: "代表取締役社長")
    let phone = MQForm.label(name: "phone", title: "Tel： 030-3765-4683")
    let mobilePhone = MQForm.label(name: "mobilePhone", title: "携帯： 090-5309-0092")
    let fax = MQForm.label(name: "fax", title: "fax: 03-0102-1201")
    let webpage = MQForm.label(name: "webpage", title: "http://localhost.com")
    let mailAddress = MQForm.label(name: "mailAddress", title: "abc@localhost.com")

    
    func load (_ card: NameCardInfo) {

        let form = self
        
        setViews(card)
        
        form +++ businessName.layout {
            b in
            b.upper(withInset: 10).leftMost(withInset: 20).height(30)
            b.label.font = UIFont.boldSystemFont(ofSize: 18)
        }
        
        form +++ businessLogo.layout {
            l in
            l.topAlign(with: self.businessName).rightMost(withInset: 30)
            l.height(40).width(40)
        }
        
        form +++ webpage.layout {
            b in
            b.putUnder(of: self.businessName).leftMost(withInset: 20).height(20)
            b.label.font = UIFont.boldSystemFont(ofSize: 12)
            b.label.textColor = MittyColor.sunshineRed
        }
        
        form +++ businessSubName.layout {
            b in
            b.putUnder(of: self.webpage).leftMost(withInset: 20).height(18)
            b.label.font = UIFont.boldSystemFont(ofSize: 15)
            b.label.textColor = UIColor(white: 0.5, alpha: 1)
        }
        
        form +++ businessTitle.layout {
            b in
            b.putUnder(of: self.businessSubName, withOffset: 5).leftMost(withInset: 80).height(20)
            b.label.font = UIFont.boldSystemFont(ofSize: 12)
            b.label.textColor = UIColor(white: 0.5, alpha: 1)
        }

        form +++ myName.layout {
            b in
            b.putUnder(of: self.businessTitle, withOffset: 2).leftMost(withInset: 80).height(25)
            b.label.font = UIFont.boldSystemFont(ofSize: 23)
        }

        let seperator = Row.LeftAligned().layout() {
            r in

            r.height(5).fillHolizon(2).putUnder(of: self.myName, withOffset: 10)
            let layer = MittyColor.gradientLayer()
            layer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 2)
            r.view.layer.insertSublayer(layer, at: 0)
        }

        form +++ seperator

        form +++ addressLine1.layout{
            addr in
            addr.putUnder(of: seperator).leftMost(withInset: 5)
            addr.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            addr.label.textColor = MittyColor.healthyGreen
        }
        
        form +++ addressLine2.layout{
            addr in
            addr.putUnder(of: self.addressLine1, withOffset: 1).leftMost(withInset: 5)
            addr.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            addr.label.textColor = MittyColor.healthyGreen

        }
        
        let contacts = Row.Intervaled()
        contacts.spacing = 5
        contacts +++ mailAddress.layout {
            b in
            b.height(15)
            b.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            b.label.textColor = MittyColor.healthyGreen
        }
        
        contacts +++ phone.layout {
            b in
            b.height(15).margin.left = 15
            b.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            b.label.textColor = MittyColor.healthyGreen
        }
        
        form +++ contacts.layout{
            row in
            row.putUnder(of: self.addressLine2).fillHolizon().height(16)
        }
        
        let numbers = Row.Intervaled()
        numbers.spacing = 5
        numbers +++ mobilePhone.layout {
            b in
            b.height(15)
            b.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            b.label.textColor = MittyColor.healthyGreen
        }
        numbers +++ fax.layout {
            b in
            b.height(15)
            b.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            b.label.textColor = MittyColor.healthyGreen
        }
        
        form +++ numbers.layout{
            row in
            row.putUnder(of: contacts).fillHolizon().height(16)
        }

        form.view.layer.masksToBounds = true
        form.view.layer.backgroundColor = UIColor(white: 0.94, alpha: 1).cgColor
        form.view.layer.borderColor = UIColor.gray.cgColor
        // form.layer.borderWidth = 0.5
        form.view.layer.shadowColor = UIColor.black.cgColor
        form.view.layer.shadowOffset = CGSize(width: -10, height: 10)
        form.view.layer.shadowOpacity = 0.8
        form.view.layer.shadowRadius = 1.8


    }
    
    func setViews(_ data: NameCardInfo) {
        businessName.label.text = data.businessName
        businessSubName.label.text = data.businessSubName
        webpage.label.text = data.webpage
        businessTitle.label.text = data.businessTitle
        myName.label.text = data.name
        addressLine1.label.text = data.addressLine1
        addressLine2.label.text = data.addressLine2
        mailAddress.label.text = data.email
        phone.label.text = data.phone
        mobilePhone.label.text = data.mobilePhone
        fax.label.text = data.fax
        
        if data.businessLogoUrl != "" {
            businessLogo.imageView.setMittyImage(url: data.businessLogoUrl)
        }
        
    }
}
