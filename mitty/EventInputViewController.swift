//
//  EventInputViewController.swift
//  mitty
//
//  Created by gridscale on 2017/11/06.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import SwiftyJSON


class EventInputViewController : ActivityPlanViewController {
    override init(_ info: ActivityInfo) {
        super.init(info)
    }
    
    //
    //
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let inputForm = super.form as! EventInputForm
        
        inputForm.registerButton.bindEvent(.touchUpInside) { [weak self]
            c in
            self?.register()
        }
        
    }
    
    override func setForm() {
        super.form = EventInputForm()
    }
    
    func register() {
        let request = NewEventReq()
        
        // type: string,          (M)      -- イベントの種類
        request.setStr(.type, type)
        
        // tag:  string,          (M)      -- イベントについて利用者が入力したデータの分類識別。
        if (form.tagList.textField.text == "") {
            showError("タグを入力してください")
            return
        }
        request.setStr(.tagList, form.tagList.textField.text)
        
        // title: string,         (M)      -- イベントタイトル
        if (form.eventTitle.textField.text == "") {
            showError("タイトルを入力してください")
            return
        }
        request.setStr(.title, form.eventTitle.textField.text)
        
        // logoId: int           (O)LogoID
        if logoContent != nil {
            request.setInt(.logoId, String(logoContent!.id))
        }
        
        // action: string,        (M)      -- イベントの行い概要内容
        if (form.action.textView.text == "") {
            showError("行い事の概要を入力してください")
            return
        }
        request.setStr(.action, form.action.textView.text)
        
        // startDate: dateTime,   (M)      -- イベント開始日時
        var dp = form.startDate.textField.inputView as! UIDatePicker
        request.setDate(.startDate, dp.date)
        
        // endDate: dateTime,     (M)      -- イベント終了日時
        dp = form.endDate.textField.inputView as! UIDatePicker
        request.setDate(.endDate, dp.date)
        
        // allDayFlag: bool,      (M)      -- 時刻非表示フラグ。
        request.setStr(.allDayFlag, "true")
        
        if (pickedIsland == nil || pickedIsland?.placeMark == nil) {
            showError("住所を入力してください")
            return
        }
        
        // islandId:  int,        (M)      -- 島ID
        request.setInt(.islandId, String(pickedIsland!.id))
        
        // priceName1: string,    (O)      -- 価格名称１
        request.setStr(.priceName1, pricePicker.priceName1.textField.text)
        
        // price1: Double ,       (O)      -- 価格額１
        let price = pricePicker.price1.textField.text
        if (price != nil && price != "") {
            request.setDouble(.price1, price!)
        }
        
        // priceName2,            (O)      -- 価格名称2
        request.setStr(.priceName2, pricePicker.priceName2.textField.text)
        
        
        // price2: Double ,       (O)      -- 価格額２
        let price2 = pricePicker.price2.textField.text
        if (price2 != nil && price != "") {
            request.setDouble(.price2, price2!)
        }
        
        // currency: string 　　　（O)      -- 通貨　(USD,JPY,などISO通貨３桁表記)
        request.setStr(.currency, pricePicker.currency.textField.text)
        
        // priceInfo: string      (O)      -- 価格について一般的な記述
        request.setStr(.priceInfo, pricePicker.priceInfo.textView.text)
        
        if (form.action.textView.text == "") {
            showError("行い事の概要を入力してください")
            return
        }
        // description: string    (M)      -- イベントについて詳細な説明記述
        request.setStr(.description, form.detailDescription.textView.text)
        
        // contactTel: string,    (O)      -- 連絡電話番号
        request.setStr(.contactTel, form.contactTel.textField.text)
        
        // contactFax: string,    (O)      -- 連絡FAX
        request.setStr(.contactFax, "-")
        
        // contactMail: string,   (O)      -- 連絡メール
        request.setStr(.contactMail, form.contactEmail.textField.text)
        
        // officialUrl: URL,      (O)      -- イベント公式ページURL
        request.setStr(.officialUrl, trim(form.officialUrl.textField.text, 200))
        
        // organizer: string,     (O)      -- 主催者の個人や団体の名称
        request.setStr(.organizer, form.organizer.textField.text)
        
        // sourceName: string,    (M)      -- 情報源の名称
        request.setStr(.sourceName, form.infoSource.textView.text)
        
        // sourceUrl: URL,        (O)      -- 情報源のWebPageのURL
        request.setStr(.sourceUrl, trim(form.infoUrl.textField.text, 200))
        
        // anticipation: string,  (O)      -- イベント参加方式、 OPEN：　自由参加、　INVITATION:招待制、PRIVATE:個人用、他の人は参加不可。
        request.setStr(.anticipation, "open")
        
        // accessControl: string, (O)      -- イベント情報のアクセス制御：　PUBLIC: 全公開、　PRIVATE: 非公開、 SHARED:関係者のみ
        request.setStr(.accessControl, "public")
        
        // language: string       (M)      -- 言語情報　(Ja_JP, en_US, en_GB) elastic　searchに使用する。
        request.setStr(.language, "Ja_JP")
        
        request.setInt(.relatedActivityId, activityInfo.id)
        if (activityInfo.mainEventId == nil || activityInfo.mainEventId == "0" || activityInfo.mainEventId == "0") {
            request.setStr(.asMainEvent, "true")
        } else {
            request.setStr(.asMainEvent, "false")
        }
        
        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]
        
        LoadingProxy.on()
        
        let api = APIClient(path: "/new/event", method: .post, parameters: request.parameters, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            if (self.imagePicked) {
                let jsonObject = data
                let json = JSON(jsonObject)
                let eventId = json["eventId"].stringValue
                self.registerGallery(eventId)
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }, fail: {(error: Error?) in
            LoadingProxy.off()
        })
    }
    
}
