//
//  NamecardExchangeViewController.swift
//  mitty
//
//  Created by gridscale on 2017/08/28.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

/// <#Description#>
class NamecardExchangeViewController: MittyViewController {
    
    let form: MQForm = MQForm.newAutoLayout()
    var myNamecards = [NameCardInfo]()
    var selectedCard : NameCardInfo?
    var contacteeCard: ContacteeNamecard!
    var contacteeUser : UserInfo!

    // 上には相手の情報
    //    Mitty User Name, Icon
    //    名刺の見出し情報（ビジネスネームとアイコン）
    let contactee = MQForm.label(name: "user-name", title: "")
    let userIcon = MQForm.img(name: "user-icon", url: "pengin4").layout{
        img in
        img.rightMost(withInset:10)
    }
    
    let contacteeBusiness = MQForm.label(name: "contactee-business", title: "")
    let contacteeBusinesssIcon = MQForm.img(name: "contactee-business-icon", url: "").layout{
        img in
        img.rightMost(withInset:10)
    }

    
    // 下には選んだ名刺のイメージ（Form)
    //   名刺フォーム
    let cardForm = NameCardForm()
    
    // 自分の名刺一覧（テーブル）
    //   名刺の見出しとアイコン
    var cardTable: Control = {
        let cardTable: UITableView = UITableView.newAutoLayout()
        let c = Control(name: "cardList", view: cardTable)
        return c
    } ()
    
    // メッセージ
    var offerMessage = MQForm.textView(name: "message")
    
    // 最下部は送信ボタン
    let sendButton = MQForm.button(name: "Send", title: "送信")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor.white
        
        self.view.backgroundColor = .white
        self.view.addSubview(form)
        
        form.autoPin(toTopLayoutGuideOf: self, withInset: 10)
        form.autoPinEdge(toSuperviewEdge: .left)
        form.autoPinEdge(toSuperviewEdge: .right)
        form.autoPinEdge(toSuperviewEdge: .bottom)
        
        buildForm()
        form.configLayout()
        
        self.navigationItem.title = "名刺交換"

        let tableView = cardTable.view as! UITableView
        tableView.delegate = self
        tableView.dataSource = self
        
        NameCardService.instance.myNameCard(onComplete: {
            cardList in
            self.myNamecards = cardList
            (self.cardTable.view as! UITableView).reloadData()
            self.sendButton.bindEvent(.touchUpInside) { b in
                self.sendOffer()
            }
        }, onError: { error in
            self.showError("名刺取得エラー")
        })
        
        
        
    }
    
    //
    func buildForm () {
        let section = Section(view: UIView.newAutoLayout())
        form +++ section.layout{
            s in
            s.fillParent()
        }
        
        let nameRow = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(30)
            r.view.backgroundColor = MittyColor.healthyGreen
        }
        section <<< nameRow
        
        contactee.label.text = contacteeUser.userName
        contactee.label.textColor = UIColor.white
        contactee.leftMargin(5)
        
        nameRow +++ contactee
        nameRow +++ userIcon.layout {
            i in
            i.height(25).width(25).upMargin(2.5)
            i.imageView.setMittyImage(url: self.contacteeUser.icon)
        }

        
        let contacteeBusinessRow = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(30)
            r.view.backgroundColor = MittyColor.healthyGreen
        }

        section <<< contacteeBusinessRow
        
        contacteeBusiness.label.text = contacteeCard.businessName
        contacteeBusiness.label.textColor = UIColor.white
        contacteeBusiness.leftMargin(5)
        
        contacteeBusinesssIcon.imageView.setMittyImage(url: contacteeCard.businessLogoUrl)
        contacteeBusinessRow +++ contacteeBusiness
        contacteeBusinessRow +++ contacteeBusinesssIcon.layout {
            i in
            i.height(25).width(25).upMargin(2.5)
        }
        
        // selected card
        let selectedRow = Row.Intervaled().layout {
            r in
            r.fillHolizon().height(140)
            r.view.backgroundColor = UIColor.black
        }
        
        super.autoCloseKeyboard(view: selectedRow.view)
        
        selectedRow.spacing = 2
        selectedRow +++ cardForm.layout{
            c in
            c.fillHolizon().height(210).down()
        }
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: 0, y: 40)
        transform = transform.scaledBy(x: 0.60, y: 0.60)
        cardForm.view.transform = transform
        
        section <<< selectedRow
        
        // card table
        let tableRow = Row.LeftAligned().layout{
            table in
            table.height(100).fillHolizon()
//            table.view.backgroundColor = UIColor.green
        }
        tableRow +++ cardTable.layout{
            c in
            c.fillParent()
//            c.view.backgroundColor = UIColor.green
        }
        section <<< tableRow
        
        // select button
        
        // message
        seperator(section: section, caption: "メッセージ")
        let messageRow = Row.LeftAligned().layout {
            r in
            r.height(60).fillHolizon()
        }
        messageRow +++ offerMessage.layout {
            m in
            m.fillHolizon().height(60)
        }
        section <<< messageRow
        
        
        let buttonRow = Row.Intervaled()
        buttonRow.spacing = 50
        
        buttonRow +++ sendButton.layout {
            b in
            b.height(50)
        }
        
        section <<< buttonRow
    }
    
    var firstTimeToShowNameCard = true
    func showNameCard() {
        if (selectedCard != nil) {
            if firstTimeToShowNameCard {
                cardForm.load(selectedCard!)
                cardForm.configLayout()
                self.view.setNeedsUpdateConstraints()
                firstTimeToShowNameCard = false
            } else {
                cardForm.setViews(selectedCard!)
            }
        }
    }
    
    func sendOffer() {
        if selectedCard == nil {
            self.showError("名刺を選択してください。")
            return
        }
        if offerMessage.textView.text == "" {
            self.showError("メッセージを設定ね。")
            return
        }
        
        let offer = Offer()
        offer.toMittyId = contacteeUser.id
        offer.repliedId = contacteeCard.namecardID
        offer.offerredId = selectedCard!.id
        offer.message = offerMessage.textView.text
        
        // TODO: Error Check
        OffersService.instance.sendNameCardOffer(offer)
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension NamecardExchangeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // セルの作成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let content = myNamecards[indexPath.row]
        
        // セルの作成とテキストの設定
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = content.businessName
        cell.textLabel?.textAlignment = .right
        
        DataRequest.addAcceptableImageContentTypes(["binary/octet-stream"])
        cell.imageView?.setMittyImage(url: content.businessLogoUrl)
        
        return cell
    }
    
    // セルがタップされた時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let _ = tableView.cellForRow(at: indexPath) {
            selectedCard = myNamecards[indexPath.row]
            showNameCard()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myNamecards.count
    }
}

