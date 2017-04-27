//
//  ActivityInputForm.swift
//  mitty
//
//  Created by gridscale on 2017/02/27.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

import UIKit
import PureLayout

class ActivityInputForm : MQForm {
    
    // 値を持つI/O項目はインスタンスメンバーとして定義
    // ヘッダーなど、表示だけで良いコントロールはインスタンス変数かする必要はないが、共通できるものは親クラスに用意する。
    
    let eventTitle = MQForm.text(name: "title" , placeHolder: "タイトル")
    
    let startDate = MQForm.text(name: "fromDateTime" , placeHolder: "開始日時")
    
    let endDate = MQForm.text(name: "toDateTime" , placeHolder: "終了日時" )
    
    let icon = MQForm.img(name: "icon" , url:"noicon")
    
    let infoSource = MQForm.textView(name: "infoSource")
    
    let action = MQForm.textView(name: "action" )
    
    let image = MQForm.img(name: "picture", url: "nolargeimg")
    
    let location = MQForm.text(name: "location" , placeHolder: "場所名を入力")
    let locationIcon = MQForm.img(name: "icon" , url:"noicon")
    
    let infoUrl = MQForm.text(name: "infoUrl" , placeHolder: "URL")
    
    let address = MQForm.text(name: "address" , placeHolder: "住所を入力")
    let contactTel = MQForm.text(name: "contact-Tel" , placeHolder: "☎️" )
    
    let contactEmail = MQForm.text(name: "contact-mail" , placeHolder: "📩")
    
    // ボタンなど、アクション必要なコントロールはインスタンスメンバーを定義し、
    // viewを直で取得できるComputedPropertyを用意
    
    //　項目単位の小さいロジックはForm中で実装して良い。
    
    func loadForm() {
        
        var page = self as MQForm
        
        let header = Header()
        header.title = "Title"
        page += header
        
        header.layout() { (v) in
            v.upper().height(30)
        }
        
        let contentSize = CGSize(width:UIScreen.main.bounds.size.width, height: 810)
        let inputContainer = scrollContainer(name:"inputContainer", contentSize: contentSize)
        
        self +++ inputContainer
        
        inputContainer.layout() { (main) in
            main.putUnder(of: header).fillHolizon().down(withInset: 10)
        }
        
        let inputForm = Section(name: "Input-Form", view: UIView.newAutoLayout())
        inputContainer +++ inputForm
        
        inputForm.layout() { c in
            c.upper().width(UIScreen.main.bounds.size.width).height(810)
        }
        
        var row = Row.LeftAligned()
        
        row +++ eventTitle.width(250).height(35)
        row +++ icon.height(45).width(45)
        
        row.layout() {
            r in
            r.height(45).fillHolizon()
        }
        inputForm <<< row
        
        row = Row.LeftAligned()
        row +++ MQForm.label(name: "label-start", title: "開始")
        row +++ startDate.width(230).height(35)
        
        row.layout() {
            r in
            r.height(40).fillHolizon()
        }
        
        inputForm <<< row

        row = Row.LeftAligned()
        row +++ MQForm.label(name: "label-End", title: "終了")
        row +++ endDate.width(230).height(35)
        
        row.layout() {
            r in
            r.height(40).fillHolizon()
        }
        inputForm <<< row
        
        row = Row.LeftAligned()
        row +++ MQForm.label(name: "label-des", title: "内容")
        row +++ action.width(250).height(60)
        action.textView.textContainer.maximumNumberOfLines = 3
        action.textView.textContainer.lineBreakMode = .byWordWrapping
        
        row.layout() {
            r in
            r.height(65).fillHolizon()
        }
        inputForm <<< row

        row = Row.LeftAligned()
        row +++ image.layout() {
            c in
            c.fillHolizon().height(200)
        }
        
        row.layout() {
            r in
            r.height(210).fillHolizon()
        }
        inputForm <<< row

        
        row = Row.LeftAligned()
        row +++ MQForm.label(name: "label-Location", title: "場所")
        row +++ location.width(210).height(35)
        row +++ locationIcon.height(45).width(45)
        
        
        row.layout() {
            r in
            r.height(45).fillHolizon()
        }
        inputForm <<< row
        
        row = Row.LeftAligned()
        row +++ MQForm.label(name: "label-Address", title: "住所")
        row +++ address.width(150).height(35)
        row.layout() {
            r in
            r.height(40).fillHolizon()
        }
        inputForm <<< row

        
        row = Row.LeftAligned()
        row +++ MQForm.label(name: "label-Tel", title: "連絡先")
        row +++ contactTel.width(150).height(35)
        
        row.layout() {
            r in
            r.height(40).fillHolizon()
        }
        inputForm <<< row
        
        row = Row.LeftAligned()
        row +++ MQForm.label(name: "label-Mail", title: "メール")
        row +++ contactEmail.width(260).height(35)
        
        row.layout() {
            r in
            r.height(40).fillHolizon()
        }
        inputForm <<< row
        
        
        row = Row.LeftAligned()
        row +++ MQForm.label(name: "label-InfoSource", title: "情報源")
        row +++ infoSource.width(260).height(70)
        row.layout() {
            r in
            r.height(75).fillHolizon()
        }
        inputForm <<< row
        
        row = Row.LeftAligned()
        row +++ MQForm.label(name: "label-URL", title: "URL")
        row +++ infoUrl.width(260).height(35)
        
        row.layout() {
            r in
            r.height(40).fillHolizon()
        }
        inputForm <<< row
        
        inputForm <<< Row.LeftAligned().height(50)
        
        row = Row.Intervaled()
        row.spacing = 40
        
        let bt = MQForm.button(name: "register", title: "登録").width(60).height(50)
        bt.layout() {
            c in
            c.view.backgroundColor = UIColor.orange
        }
        
        row +++ bt
        row +++ MQForm.button(name: "cancel", title: "キャンセル").width(60).height(50)
        
        row.layout() {
            r in
            r.height(55).fillHolizon()
        }
        
        inputForm <<< row
        
    }

}
