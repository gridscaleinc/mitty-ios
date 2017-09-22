//
//  NamecardPicker.swift
//  mitty
//
//  Created by gridscale on 2017/09/20.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

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
class NamecardPicker: MittyViewController {
    
    let form: MQForm = MQForm.newAutoLayout()
    var myNamecards = [NameCardInfo]()
    var selectedCard : NameCardInfo?

    
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
    
    // 最下部は送信ボタン
    let okButton = MQForm.button(name: "OK", title: "OK")
    
    // クリアボタン
    let clearButton = MQForm.button(name: "Clear", title: "Clear")
    
    init(onSelected: @escaping (_ c: NameCardInfo) -> Void, onClear: @escaping  () -> Void) {
        self.selectCard = onSelected
        self.clearCard = onClear
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        self.navigationItem.title = "名刺選択"
        
        let tableView = cardTable.view as! UITableView
        tableView.delegate = self
        tableView.dataSource = self
        
        NameCardService.instance.myNameCard(onComplete: {
            cardList in
            self.myNamecards = cardList
            (self.cardTable.view as! UITableView).reloadData()
            self.okButton.bindEvent(.touchUpInside) { b in
                if self.selectedCard != nil {
                    self.selectCard(self.selectedCard!)
                }
                
                self.navigationController?.popViewController(animated: true)
            }
            
            self.clearButton.bindEvent(.touchUpInside) { b in
                self.clearCard()
                self.navigationController?.popViewController(animated: true)
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
        
        // selected card
        let selectedRow = Row.Intervaled().layout {
            r in
            r.fillHolizon().height(250)
            r.view.backgroundColor = UIColor.black
        }
        
        super.autoCloseKeyboard(view: selectedRow.view)
        
        selectedRow.spacing = 2
        selectedRow +++ cardForm.layout{
            c in
            c.fillHolizon().height(220).verticalCenter()
        }
        
        section <<< selectedRow
        
        seperator(section: section, caption: "名刺一覧")
        
        // card table
        let tableRow = Row.LeftAligned().layout{
            table in
            table.height(190).fillHolizon()
            //            table.view.backgroundColor = UIColor.green
        }
        
        tableRow +++ cardTable.layout{
            c in
            c.fillParent()
            //            c.view.backgroundColor = UIColor.green
        }
        section <<< tableRow
        
        // select button
        
        
        let buttonRow = Row.Intervaled().upMargin(30).height(30)
        buttonRow.spacing = 50
        
        buttonRow +++ okButton.layout {
            b in
            b.height(30)
        }
        
        
        buttonRow +++ clearButton.layout {
            b in
            b.height(30)
        }
        
        section <<< buttonRow
        
        section <<< Row.LeftAligned()
        
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
    
    var selectCard : ((_ c: NameCardInfo) -> Void)
    
    var clearCard : (() -> Void)
}

extension NamecardPicker: UITableViewDelegate, UITableViewDataSource {
    
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


