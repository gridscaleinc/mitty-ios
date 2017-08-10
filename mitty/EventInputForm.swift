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

//
//
//
class EventInputForm : MQForm {
    
    // 値を持つI/O項目はインスタンスメンバーとして定義
    // ヘッダーなど、表示だけで良いコントロールはインスタンス変数かする必要はないが、共通できるものは親クラスに用意する。
    
    let eventTitle = MQForm.text(name: "title" , placeHolder: "イベントタイトル")
    
    let tagList = MQForm.text(name: "tag" , placeHolder: "tag1 tag2 複数可...")
    
    // イベントIcon
    let icon = MQForm.tapableImg(name: "icon" , url:"noicon")
 
    // 開始日時
    let startDate = MQForm.text(name: "fromDateTime" , placeHolder: "開始日時")
    
    //  終了日時
    let endDate = MQForm.text(name: "toDateTime" , placeHolder: "終了日時" )
    
    // 終日フラグ
    let allDayFlag = MQForm.switcher(name: "allDayFlg")
   
    // 行い
    let action = MQForm.textView(name: "action" )
    
    let priceInput = MQForm.button(name: "priceInput" , title: "価格を入力" )
    let price1 = MQForm.label(name: "price1", title: "")
    var price1Row : Row? = nil

    let price2 = MQForm.label(name: "price2", title: "")
    var price2Row : Row? = nil

    let priceDetail = MQForm.label(name: "priceDetail", title: "")
    var priceDetailRow : Row? = nil
    
    
    // 場所
    let location = MQForm.text(name: "location" , placeHolder: "場所名を入力")
    let locationIcon = MQForm.img(name: "icon" , url:"noicon")
    let addressLabel = MQForm.label(name: "label-Address", title: "住所")
    let address = MQForm.label(name: "address" , title: "")
    
    var addressRow : Row? = nil
    
    // 情報源
    let infoSource = MQForm.textView(name: "infoSource")
    let infoUrl = MQForm.text(name: "infoUrl" , placeHolder: "情報源のURL")

    // 連絡情報（FAXは？）
    let contactTel = MQForm.text(name: "contact-Tel" , placeHolder: "☎️ 電話番号" )
    let contactEmail = MQForm.text(name: "contact-mail" , placeHolder: "📩 メールアドレス")
    let officialUrl = MQForm.text(name: "officialUrl" , placeHolder: "公式ホームページURL")
    
    let detailDescription = MQForm.textView(name: "description")
    
    let organizer = MQForm.text(name: "organizer", placeHolder: "主催者名称")
    
    // イメージは最後にオプションとして洗濯させる。
    let image : Control = {
        let i = MQForm.img(name: "picture", url: "sunnyGreen")
        i.image.contentMode = .scaleAspectFit
        return i
    } ()

    // ボタンなど、アクション必要なコントロールはインスタンスメンバーを定義し、
    // viewを直で取得できるComputedPropertyを用意
    let registerButton = MQForm.button(name: "register", title: "登録")
    let cancelButton = MQForm.button(name: "cancel", title: "キャンセル")
    
    //　項目単位の小さいロジックはForm中で実装して良い。
    
    func loadForm() {
        self.backgroundColor = .white
        self.backgroundColor = UIColor(patternImage: UIImage(named: "beauty2.jpeg")!)
        
        let row_height = CGFloat(50)
        let line_height = CGFloat(48)
        
        var page = self as MQForm
        
        let header = Header()
        header.title = "Title"
        page += header
        
        header.layout() { (v) in
            v.upper().height(2)
        }
        
        let inputContainer = scrollContainer(name:"inputContainer")
        
        self +++ inputContainer
        
        inputContainer.layout() { (main) in
            main.putUnder(of: header).fillHolizon().down(withInset: 0)
        }
        
        let inputForm = Section(name: "Input-Form", view: UIView.newAutoLayout())
        inputContainer +++ inputForm
        
        var row = Row.LeftAligned()
        row.layout {
            r in
            r.fillHolizon(0).height(35)
            r.view.backgroundColor = .orange
        }
        
        row +++ MQForm.label(name: "title-main-event", title: "イベント情報登録").layout {
            c in
            c.height(40)
            c.leftMost(withInset: 20)
            let l = c.view as! UILabel
            l.textColor = .white
            l.font = .systemFont(ofSize: 16)
        }
        inputForm <<< row
        
        row = Row.LeftAligned()
        
        row +++ eventTitle.layout {
            l in
            l.rightMost(withInset: 60).height(line_height)
        }
        row +++ icon.height(50).width(50)
        
        row.layout() {
            r in
            r.height(row_height).fillHolizon()
        }
        
        inputForm <<< row
        
        row = Row.LeftAligned()
        
        row +++ tagList.layout {
            t in
            t.fillHolizon(10).height(line_height)
        }
        row.layout() {
            r in
            r.height(row_height).fillHolizon()
        }
        inputForm <<< row
        
        seperator(section: inputForm, caption: "行い内容")
        row = Row.LeftAligned()
        row +++ action.layout {
            line in
            line.height(line_height).rightMost(withInset: 10)
        }
        
        action.textView.textContainer.maximumNumberOfLines = 3
        action.textView.textContainer.lineBreakMode = .byWordWrapping
        
        row.layout() {
            r in
            r.height(row_height).fillHolizon()
        }
        inputForm <<< row
        
        row = Row.LeftAligned()
        let imageContainer = Container(name: "iamgeCont", view:UIView.newAutoLayout())
        row +++ imageContainer.layout {
            i in
            i.fillParent()
        }
        
        imageContainer +++ image.layout() {
            c in
            c.height(UIScreen.main.bounds.width).fillHolizon().upper()
        }
        
        imageContainer +++ MQForm.label(name: "addImageLabel", title: "＋画像").height(120).width(90).layout {
            l in
            l.label.textColor = MittyColor.healthyGreen
            l.label.textAlignment = .center
            l.label.font = UIFont.boldSystemFont(ofSize: 30)
            l.fillHolizon().upper()
        }
        
        row.layout() {
            r in
            r.height(UIScreen.main.bounds.width).fillHolizon()
        }
        inputForm <<< row
        

        seperator(section: inputForm, caption: "日程")
        //終日フラグ
        row = Row.LeftAligned()
        row +++ MQForm.label(name: "alldayFlagTitle", title: "終日").width(60).height(line_height)
        row +++ allDayFlag.layout{
            flag in
            flag.down().width(45)
        }
        row.layout() {
            r in
            r.height(row_height).fillHolizon()
        }
        inputForm <<< row
        
        row = Row.LeftAligned()
        row +++ MQForm.label(name: "label-start", title: "開始").height(line_height).width(60)
        row +++ startDate.layout{
            line in
            line.textField.textColor = MittyColor.healthyGreen
            line.textField.attributedPlaceholder = NSAttributedString(string:"開始日付・時刻を入力", attributes: [NSForegroundColorAttributeName: MittyColor.healthyGreen])
            line.height(line_height).rightMost(withInset: 10)
        }
        
        row.layout() {
            r in
            r.height(row_height).fillHolizon()
        }
        
        inputForm <<< row

        row = Row.LeftAligned()
        row +++ MQForm.label(name: "label-End", title: "終了").height(line_height).width(60)
        row +++ endDate.layout{
            line in
            line.textField.textColor = MittyColor.healthyGreen
            line.textField.attributedPlaceholder = NSAttributedString(string:"終了日付・時刻を入力", attributes: [NSForegroundColorAttributeName: MittyColor.healthyGreen])
            line.height(line_height).rightMost(withInset: 10)
        }
        
        row.layout() {
            r in
            r.height(row_height).fillHolizon()
        }
        inputForm <<< row
        
        seperator(section: inputForm, caption: "場所")
        row = Row.LeftAligned()
        row +++ location.layout{
            line in
            line.textField.textColor = MittyColor.healthyGreen
            line.textField.attributedPlaceholder = NSAttributedString(string:"場所名・住所などを入力", attributes: [NSForegroundColorAttributeName: MittyColor.healthyGreen])
            line.height(line_height).rightMost(withInset: 60)
        }
        row +++ locationIcon.height(line_height).width(line_height)
        
        
        row.layout() {
            r in
            r.height(row_height).fillHolizon()
        }
        inputForm <<< row
        
        row = Row.LeftAligned()
        addressRow = row
        row +++ addressLabel.layout {
            l in
            l.height(0).width(60)
        }
        row +++ address.layout {
            line in
            line.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            line.label.isUserInteractionEnabled = false
            line.label.textColor = UIColor.gray
            line.label.numberOfLines = 0
            line.height(0).rightMost(withInset: 10)
        }

        row.layout() {
            r in
            r.height(row_height).fillHolizon()
        }
        inputForm <<< row
        
        seperator(section: inputForm, caption: "詳細")
        row = Row.LeftAligned()
        row +++ detailDescription.layout{
            line in
            line.height(90).rightMost(withInset: 10)
        }
        
        row.layout() {
            r in
            r.height(100).fillHolizon()
        }
        inputForm <<< row
        

        seperator(section: inputForm, caption: "価格")
        row = Row.LeftAligned().height(row_height)
        row +++ MQForm.label(name: "price", title: "価格").height(line_height).width(60)
        row +++ priceInput.layout{
            line in
            line.button.setTitleColor(MittyColor.healthyGreen, for: .normal)
            line.button.backgroundColor = .white
            line.button.layer.borderWidth = 0
            
            line.height(line_height).rightMost(withInset: 10)
        }
        
        inputForm <<< row

        price1Row = Row.LeftAligned().height(20)
        price1Row! +++ price1.layout {
            p in
            p.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            p.label.textColor = .gray
            p.fillHolizon(20)
        }
        
        inputForm <<< price1Row!
        
        price2Row = Row.LeftAligned().height(20)
        price2Row! +++ price2.layout {
            p in
            p.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            p.label.textColor = .gray
            p.fillHolizon(20)

        }
        
        inputForm <<< price2Row!
        
        priceDetailRow = Row.LeftAligned().height(30)
        priceDetailRow! +++ priceDetail.layout {
            p in
            p.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            p.label.textColor = .gray
            p.fillHolizon(20)
        }
        
        inputForm <<< priceDetailRow!
        
        seperator(section: inputForm, caption: "問い合わせ・連絡情報")
        row = Row.LeftAligned()
        row +++ MQForm.label(name: "label-Tel", title: "連絡先").height(line_height).width(70)
        row +++ contactTel.layout{
            line in
            line.height(line_height).rightMost(withInset: 10)
        }
        
        row.layout() {
            r in
            r.height(row_height).fillHolizon()
        }
        inputForm <<< row
        
        row = Row.LeftAligned()
        row +++ MQForm.label(name: "label-Mail", title: "メール").height(line_height).width(60)
        row +++ contactEmail.layout{
            line in
            line.height(line_height).rightMost(withInset: 10)
        }

        
        row.layout() {
            r in
            r.height(row_height).fillHolizon()
        }
        inputForm <<< row
        row = Row.LeftAligned()
        row +++ MQForm.label(name: "label-official-page", title: "+公式ページ").layout {
            c in
            c.height(line_height).width(100)
            c.label.textColor = MittyColor.healthyGreen
        }
        row +++ officialUrl.layout{
            line in
            line.height(line_height).rightMost(withInset: 10)
        }

        row.layout() {
            r in
            r.height(row_height).fillHolizon()
        }
        inputForm <<< row

        seperator(section: inputForm, caption: "情報源")
        row = Row.LeftAligned()
        row +++ infoSource.layout{
            line in
            line.height(line_height).rightMost(withInset: 10)
        }
        row.layout() {
            r in
            r.height(row_height).fillHolizon()
        }
        inputForm <<< row
        
        row = Row.LeftAligned()
        row +++ infoUrl.layout{
            line in
            line.textField.textColor = MittyColor.healthyGreen
            line.textField.attributedPlaceholder = NSAttributedString(string:"情報源URLを入力", attributes: [NSForegroundColorAttributeName: MittyColor.healthyGreen])
            line.height(line_height).rightMost(withInset: 10)

        }
        
        row.layout() {
            r in
            r.height(row_height).fillHolizon()
        }
        inputForm <<< row
        
        seperator(section: inputForm, caption: "主催者")
        row = Row.LeftAligned()
        row +++ organizer.layout{
            line in
            line.height(line_height).rightMost(withInset: 10)
        }
        
        row.layout() {
            r in
            r.height(row_height).fillHolizon()
        }
        inputForm <<< row
        
        inputForm <<< Row.LeftAligned().height(50)
        
        row = Row.Intervaled().layout() {
            r in
            r.height(55).fillHolizon()
        }
        row.spacing = 20
        
        row +++ registerButton.width(60).height(50).layout() {
            c in
            c.view.backgroundColor = UIColor.orange
        }
        
        row +++ cancelButton.width(60).height(50)
        
        
        inputForm <<< row
        
        row = Row.Intervaled().layout() {
            r in
            r.height(20).fillHolizon()
        }

        inputForm <<< row
        
        inputForm.layout() { c in
            c.fillVertical().width(UIScreen.main.bounds.width).bottomAlign(with: row)
            c.view.backgroundColor = .white
        }
        
    }

    func seperator(section : Section, caption: String) {
        let row = Row.Intervaled().layout() {
            r in
            r.height(23).fillHolizon()
        }
        
        let c = MQForm.label(name: "caption", title: caption).layout {
            c in
            c.height(20)
            c.label.backgroundColor = MittyColor.light
            c.label.textColor = .gray
            c.label.textAlignment = .center
            c.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        }
        row +++ c
        section <<< row
    }
    
    func updateLayout () {
        
        addressLabel.heightConstraints?.autoRemove()
        address.heightConstraints?.autoRemove()
        addressRow?.heightConstraints?.autoRemove()
        
        if address.label.text != "" {
            addressLabel.height(48)
            address.height(48)
            addressRow?.height(48)
        } else {
            addressLabel.height(0)
            address.height(0)
            addressRow?.height(0)
        }
        
        price1Row?.heightConstraints?.autoRemove()
        price1.heightConstraints?.autoRemove()
        price2Row?.heightConstraints?.autoRemove()
        price2.heightConstraints?.autoRemove()
        priceDetailRow?.heightConstraints?.autoRemove()
        priceDetail.heightConstraints?.autoRemove()
        
        
        if price1.label.text != "" {
            price1Row?.height(15)
            price1.height(15)
        } else {
            price1Row?.height(0)
            price1.height(0)
        }
        
        if price2.label.text != "" {
            price2Row?.height(15)
            price2.height(15)
        } else {
            price2Row?.height(0)
            price2.height(0)
        }
        
        if priceDetail.label.text != "" {
            priceDetailRow?.height(60)
            priceDetail.height(60)
        } else {
            priceDetailRow?.height(0)
            priceDetail.height(0)
        }
        
        
    }
    
    
}
