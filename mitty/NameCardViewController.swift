//
//  NameCardViewController.swift
//  mitty
//
//  Created by gridscale on 2017/06/26.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

/// <#Description#>
class NameCardViewController: MittyViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ContentPickerDelegate  {
    
    let form: MQForm = MQForm.newAutoLayout()
    
    var nameCard = NameCardInfo()
    var cardform = NameCardForm()
    var inputForm = NameCardInputForm()
    var content: Content = Content()
    
    var okButton = MQForm.button(name: "ok", title: "OK")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.autoCloseKeyboard()
        
        self.view.backgroundColor = UIColor.white
        
    
        self.view.addSubview(form)
        self.view.backgroundColor = .white
        
        buildForm()
    
        form.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        form.autoPinEdge(toSuperviewEdge: .left)
        form.autoPinEdge(toSuperviewEdge: .right)
        form.autoPinEdge(toSuperviewEdge: .bottom)
        
        self.view.setNeedsUpdateConstraints()
        
        for c in inputForm.selectAll().controls {
            if c.view is UITextField {
                c.bindEvent(.editingChanged) {
                    t in
                    
                    let n = c.name
                    let label = self.cardform[n]?.label
                    if (label == nil) {
                        return
                    }
                    label?.text = c.textField.text
                    
                }
                c.view.backgroundColor = MittyColor.lightYellow
            }
        }
        
        // navi
        inputForm.logoButton.bindEvent(.touchUpInside) {
            ic in
            let vc = ContentPicker()
            
            vc.delegate = self
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        okButton.bindEvent(.touchUpInside) {
            b in
            self.saveNameCard()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        
        super.updateViewConstraints()
        
        form.configLayout()
    }
    
    
    func pickedContent(content: Content) {
        self.content = content
        if (content.linkUrl != "") {
            cardform.businessLogo.imageView.setMittyImage(url: content.linkUrl!)
        }
    }
    
    func clearPickedContent() {
        self.content = Content()
    }
    
    func buildForm() {
        
        form.backgroundColor = UIColor(patternImage: UIImage(named: "beauty2.jpeg")!)

        cardform.load(nameCard)
        cardform.layout {
            c in
            c.fillHolizon().upper().height(220)
        }
        
        form +++ cardform
        // cardform.view.transform = CGAffineTransform(scaleX: 0.52, y: 0.52);
        // スクロールViewを作る
        let scroll = UIScrollView.newAutoLayout()
        scroll.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 900)
        scroll.isScrollEnabled = true
        scroll.flashScrollIndicators()
        scroll.canCancelContentTouches = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        let scrollContainer = Container(name: "Detail-form", view: scroll).layout() { (container) in
            container.fillHolizon().putUnder(of: self.cardform).down()
        }
        
        form +++ scrollContainer
        
        let detailForm = Section(name: "Content-Form", view: UIView.newAutoLayout())
        scrollContainer +++ detailForm
        detailForm <<< Row.LeftAligned().layout{
            r in
            r.fillHolizon().height(20)
            r.view.backgroundColor = .black
        }
        
        let titleRow = Row.Intervaled().layout {
            r in
            r.fillHolizon()
        }
        
        titleRow +++ MQForm.label(name: "title", title: "名刺データを入力").layout{
            l in
            l.verticalCenter()
            l.label.textAlignment = .center
            l.label.textColor = MittyColor.lightYellow
        }
        
        detailForm <<< titleRow
        
        inputForm.load(nameCard)
        inputForm.view.backgroundColor = .black
        let row = Row.LeftAligned()
        row +++ inputForm.layout {
            c in
            c.fillHolizon().upper().bottomAlign(with: self.inputForm.fax, withOffset: 20)
        }
        row.layout{
            r in
            r.fillHolizon().topAlign(with: self.inputForm).bottomAlign(with: self.inputForm)
        }
        detailForm <<< row
        
        let buttonRow = Row.Intervaled().layout {
            r in
            r.fillHolizon().height(50)
        }
        buttonRow.spacing = 80
        
        buttonRow +++ okButton
        
        detailForm <<< buttonRow
        
        let bottom = Row.LeftAligned().layout {
            r in
            r.fillHolizon()
        }
        
        detailForm <<< bottom
        
        detailForm.layout {
            f in
            f.fillVertical().width(UIScreen.main.bounds.width).bottomAlign(with: bottom)
            f.view.autoSetDimension(.height, toSize: UIScreen.main.bounds.height - 220, relation: .greaterThanOrEqual)
            f.view.backgroundColor = UIColor.white
        }
        
    }
    
    // Call namecard service to upload data
    func saveNameCard() {
        if checkInputForm() {
            setNameCard()
            NameCardService.instance.saveNameCard(nameCard, onComplete: {}, onError:{
                error in
            })
        }
    }
    
    func checkInputForm() -> Bool {
        if inputForm.myName.textField.text == "" {
            showError("名前が未入力")
            return false
        }
        
        if inputForm.businessName.textField.text == "" {
            showError("会社/組織名が未入力")
            return false
        }
        
        if !isValidEmail(inputForm.mailAddress) {
            showError("メールアドレスが正しくない。")
            return false
        }
        
        return true
    }

    /**
     */
    func isValidEmail(_ f: Control) -> Bool {
        let email = f.textField.text
        if email != "" {
            let rexg = try! NSRegularExpression(pattern: "(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$)")
            return rexg.numberOfMatches(in: email!, options: [], range: NSMakeRange(0, (email!.characters.count))) > 0
        }
        
        return true
    }
    
    
    /// <#Description#>
    func setNameCard() {
        nameCard.name = inputForm.myName.textField.text!
        nameCard.businessName = inputForm.businessName.textField.text!
        nameCard.businessSubName = inputForm.businessSubName.textField.text!
        nameCard.webpage = inputForm.webpage.textField.text!
        nameCard.businessTitle = inputForm.businessTitle.textField.text!
        nameCard.addressLine1 = inputForm.addressLine1.textField.text!
        nameCard.addressLine2 = inputForm.addressLine2.textField.text!
        nameCard.email = inputForm.mailAddress.textField.text!
        nameCard.phone = inputForm.phone.textField.text!
        nameCard.mobilePhone = inputForm.mobilePhone.textField.text!
        nameCard.fax = inputForm.fax.textField.text!
        if ( content.id != 0) {
            nameCard.businessLogoId = content.id
        }
    }
}

