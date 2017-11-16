//
//  ActivityPlanEditController.swift
//  mitty
//
//  Created by gridscale on 2017/10/10.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import MapKit
import AlamofireImage

class EventModifyViewController : ActivityPlanViewController {
    
    var event: Event!
    
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
        
        let modifyForm = super.form as! EventModifyForm
        
        setEvent(event)
        
        
        modifyForm.modifyButton.bindEvent(.touchUpInside) { [weak self]
            c in
            self?.saveChanges()
        }
        
    }
    
    func setEvent(_ event: Event) {
        form.eventTitle.textField.text = event.title
        form.tagList.textField.text = event.tag
        form.action.textView.text = event.action
        
        form.icon.imageView.setMittyImage(url: event.eventLogoUrl)
        
        let islandPick = IslandPick()
        islandPick.id = Int64(event.islandId) ?? 0
        islandPick.name = event.isLandName
        
        pickedIsland(landInfo: islandPick)
        
        
        let picker1 = form.startDate.textField.inputView as! UIDatePicker
        let picker2 = form.endDate.textField.inputView as! UIDatePicker
        
        
        picker1.date = event.startDate
        setFromDateTime(picker1)
        
        if (event.endDate != .nulldate) {
            picker2.date = event.endDate
            setToDateTime(picker2)
        }
        
        // TODO: Price Info not set yet
        
        form.setImageUrl(event.coverImageUrl)
        
        form.detailDescription.textView.text = event.description
        form.infoSource.textView.text = event.sourceName
        form.infoUrl.textField.text = event.sourceUrl
        form.contactTel.textField.text = event.contactTel
        form.contactEmail.textField.text = event.contactMail
        
        form.officialUrl.textField.text = event.officialUrl
        form.organizer.textField.text = event.organizer
        
        
        // priceName1: string,    (O)      -- 価格名称１
        pricePicker.priceName1.textField.text = event.priceName1
        // price1: Double ,       (O)      -- 価格額１
        pricePicker.price1.textField.text = event.price1
        
        // priceName2,            (O)      -- 価格名称2
        pricePicker.priceName2.textField.text = event.priceName2
        // price2: Double ,       (O)      -- 価格額２
        pricePicker.price2.textField.text = event.price2
        
        // currency: string 　　　（O)      -- 通貨　(USD,JPY,などISO通貨３桁表記)
        pricePicker.currency.textField.text = event.currency
        // priceInfo: string      (O)      -- 価格について一般的な記述
        pricePicker.priceInfo.textView.text = event.priceInfo
        
        pickedPrice(pricePicker)

        form.updateLayout()
    }
    
    override func setForm() {
        super.form = EventModifyForm()
    }
    
    
    func saveChanges() {
        let request = NewEventReq()
        
        // Event ID
        request.setStr(.id, event.id)
        
        // type: string,          (M)      -- イベントの種類
        request.setStr(.type, event.type)
        
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
        } else {
            request.setInt(.logoId, String(event.eventLogoId))
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
            // islandId:  int,        (M)      -- 島ID
            request.setInt(.islandId, event.islandId)
        } else {
            // islandId:  int,        (M)      -- 島ID
            request.setInt(.islandId, String(pickedIsland!.id))
        }
        
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
        
        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]
        
        LoadingProxy.on()
        
        print(request.parameters)
        
        let api = APIClient(path: "/update/event", method: .post, parameters: request.parameters, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            
            // TODO全開のGalleryはどうする?
            if (self.imagePicked) {
                self.registerGallery(self.event.id, self.event.galleryId)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }, fail: {(error: Error?) in
            LoadingProxy.off()
        })
    }
}
