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
    
    func loadForm() {
        
        var page = self as MQForm
        
        let header = Header()
        header.title = "Title"
        page += header
        
        header.layout() { (v) in
            v.upper().height(30)
        }
        
        let scroll = UIScrollView.newAutoLayout()
        scroll.contentSize = CGSize(width:UIScreen.main.bounds.size.width, height:600)
        scroll.isScrollEnabled = true
        scroll.flashScrollIndicators()
        scroll.canCancelContentTouches = false
        
        let inputContainer = Container(name: "Input-Container", view: scroll)
        
        self +++ inputContainer
        
        inputContainer.layout() { (main) in
            main.putUnder(of: header).fillHolizon().down(withInset: 10)
        }
        
        let inputForm = Section(name: "Input-Form", view: UIView.newAutoLayout())
        inputContainer +++ inputForm
        
        inputForm.layout() { c in
            c.upper().width(UIScreen.main.bounds.size.width).height(600)
        }
        
        var row = Row.LeftAligned()
        
        row +++ text(name: "title" , placeHolder: "タイトル"  , width: 250).height(35)
        row +++ img(name: "icon" , url:"timesquare").height(35).width(35)
        
        row.layout() {
            r in
            r.height(40).fillHolizon()
        }
        inputForm <<< row
        
        row = Row.LeftAligned()
        row +++ label(name: "label-start", title: "開始")
        row +++ text(name: "fromDateTime" , placeHolder: "開始日時"  , width: 200).height(35)
        
        row.layout() {
            r in
            r.height(40).fillHolizon()
        }
        
        inputForm <<< row

        row = Row.LeftAligned()
        row +++ label(name: "label-End", title: "終了")
        row +++ text(name: "toDateTime" , placeHolder: "終了日時"  , width: 200).height(35)
        
        row.layout() {
            r in
            r.height(40).fillHolizon()
        }
        inputForm <<< row
        
        row = Row.LeftAligned()
        row +++ label(name: "label-des", title: "メモ")
        row +++ text(name: "memo" , placeHolder: "メモ"  , width: 250).height(60)
        
        row.layout() {
            r in
            r.height(65).fillHolizon()
        }
        inputForm <<< row

        
        row = Row.LeftAligned()
        row +++ label(name: "label-Location", title: "場所")
        row +++ text(name: "location" , placeHolder: "場所名を入力"  , width: 220).height(35)
        row +++ img(name: "icon" , url:"timesquare").height(35).width(35)
        
        
        row.layout() {
            r in
            r.height(40).fillHolizon()
        }
        inputForm <<< row
        
        row = Row.LeftAligned()
        row +++ label(name: "label-Address", title: "住所")
        row +++ text(name: "address" , placeHolder: "住所を入力"  , width: 260).height(35)
        row.layout() {
            r in
            r.height(40).fillHolizon()
        }
        inputForm <<< row

        
        row = Row.LeftAligned()
        row +++ label(name: "label-Tel", title: "連絡先")
        row +++ text(name: "contact-Tel" , placeHolder: "☎️"  , width: 150).height(35)
        row.layout() {
            r in
            r.height(40).fillHolizon()
        }
        inputForm <<< row
        
        row = Row.LeftAligned()
        row +++ label(name: "label-Mail", title: "メール")
        row +++ text(name: "contact-mail" , placeHolder: "📩"  , width: 260).height(35)
        row.layout() {
            r in
            r.height(40).fillHolizon()
        }
        inputForm <<< row
        
        
        row = Row.LeftAligned()
        row +++ label(name: "label-InfoSource", title: "情報源")
        row +++ text(name: "infoSource" , placeHolder: "ウェブサイトなどの情報"  , width: 260).height(70)
        row.layout() {
            r in
            r.height(75).fillHolizon()
        }
        inputForm <<< row
        
        row = Row.LeftAligned()
        row +++ label(name: "label-URL", title: "URL")
        row +++ text(name: "infoUrl" , placeHolder: "URL"  , width: 260).height(35)
        row.layout() {
            r in
            r.height(40).fillHolizon()
        }
        inputForm <<< row
        
        inputForm <<< Row.LeftAligned().height(50)
        
        row = Row.Intervaled()
        row.spacing = 40
        
        let bt = button(name: "register", title: "登録").width(60).height(50)
        bt.layout() {
            c in
            c.view.backgroundColor = UIColor.orange
        }
        
        row +++ bt
        row +++ button(name: "cancel", title: "キャンセル").width(60).height(50)
        
        row.layout() {
            r in
            r.height(55).fillHolizon()
        }
        
        inputForm <<< row
        
        
        
    //    self +++ thisYearButton
    //    thisYearButton.event(.touchUpInside) { [weak self]
    //        c in
    //        self?.quest().forEach() {
    //            ct in
    //            print(ct.name)
    //            print(ct.view.bounds)
    //            print(ct.view.frame)
    //        }
    //  }
        
    }

}
