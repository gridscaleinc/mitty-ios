//
//  EventService.swift
//  mitty
//
//  Created by gridscale on 2016/11/06.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

// シングルトンサービスクラス。
class EventService {
    let urlSearch = "http://dev.mitty.co/api/search/event"
    let urlFetch = "http://dev.mitty.co/api/event/of"
    
    static var instance : EventService = {
        let instance = EventService()
        return instance
    }()
    
    var images = ["event1", "event6", "event4","event10","event5"]
    
    private init() {
        
    }

    // サーバーからイベントを検索。
    func search(keys : String, callback: @escaping (_ events: [EventInfo]) -> Void ) {
        let parmeters = [
            "q" : keys
        ]
        
        LoadingProxy.on()
        
        // ダミーコード、本当はサーバーから検索する。
        var events = [EventInfo]()
        let request = Alamofire.request(urlSearch, method: .get, parameters: parmeters)
        request.validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                LoadingProxy.off()
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    print(json)
                    if (json == nil || json["events"] == nil) {
                        callback([])
                        return
                    }

                    for ( _, jsonEvent) in json["events"] {
                        events.append(self.bindEventInfo(jsonEvent))
                    }
                }
                
                callback(events)
                
            case .failure(let error):
                LoadingProxy.off()
                print(error)
            }
        }
    }

    func bindEventInfo(_ jsEvent: JSON) -> EventInfo {
        
        let e = EventInfo()
        
        print(jsEvent)
        //  イベント情報
         e.id = jsEvent["id"].stringValue
         e.title = jsEvent["title"].stringValue                        // イベントタイトル
         e.action = jsEvent["title"].stringValue                       // イベントの行い概要内容
         e.startDate = Date.bindDate(jsEvent["startDatetime"].stringValue)
                                                                       // イベント開始日時  ISO8601-YYYY-MM-DDTHH:mm:ssZ
         e.endDate = Date.bindDate(jsEvent["endDatetime"].stringValue)
                                                                       // イベント終了日時　ISO8601-YYYY-MM-DDTHH:mm:ssZ
         e.allDayFlag = jsEvent["allDayFlag"].boolValue                // 時刻非表示フラグ。
         e.eventLogoUrl = jsEvent["eventLogoUrl"].stringValue          // 該当イベントのLogoIdが指すContentsのLinkUrl
         e.imageUrl = jsEvent["imageUrl"].stringValue                  // galleryId<>Nullの場合、該当GalleryId, Seq=1のコンテンツ
                                                                       // のLinkUrl
         e.priceName1 = jsEvent["priceName1"].stringValue              // 価格名称１
         e.price1 = jsEvent["price1"].stringValue                      // 価格額１
         e.priceName2 = jsEvent["priceName2"].stringValue              // 価格名称2
         e.price2 = jsEvent["price2"].stringValue                      // 価格額２
         e.currency = jsEvent["currency"].stringValue                  // 通貨　(USD,JPY,などISO通貨３桁表記)
         e.priceInfo = jsEvent["priceInfo"].stringValue                // 価格について一般的な記述
         e.participation = jsEvent["participation"].stringValue        //   イベント参加方式、 OPEN：　自由参加、
                                                                       //    INVITATION:招待制、PRIVATE:個人用、他の人は参加不可。
         e.accessControl = jsEvent["accessControl"].stringValue        //     イベント情報のアクセス制御：　PUBLIC: 全公開、
                                                                       //    PRIVATE: 非公開、 SHARED:関係者のみ
         e.likes = jsEvent["likes"].stringValue                        //   いいねの数
        
         // 島情報
         e.islandName = jsEvent["islandName"].stringValue              // isLandIdに結びつく島名称
         e.islandLogoUrl = jsEvent["islandLogoUrl"].stringValue        // 該当island（島）のlogo_idが指すContentsのLinkURL
                                                                       //  投稿者情報
         e.publisherName = jsEvent["publisherName"].stringValue        // 投稿者の名前
         e.publisherIconUrl = jsEvent["publisherIconUrl"].stringValue  // 投稿者のアイコンのURL
         e.publishedDays = jsEvent["publishedDays"].stringValue        // 何日たちましたか

        return e
    }
    
    func fetch(id: String, callback: @escaping (Event)  -> Void ) {
        let parmeters = [
            "id" : id
        ]
        
        LoadingProxy.on()
        
        // ダミーコード、本当はサーバーから検索する。
        let request = Alamofire.request(urlFetch, method: .get, parameters: parmeters)
        request.validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                LoadingProxy.off()
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)["event"]
                    let event = self.bindEvent(json)
                    callback(event)
                }
                
            case .failure(let error):
                LoadingProxy.off()
                print(error)
            }
        }

    }

    func bindEvent(_ json: JSON) -> Event {
        let e = Event()
        
        e.id = json["id"].stringValue
        
        //  イベントの種類
        e.type = json["type"].stringValue
        
        //  カテゴリー
        e.category = json["category"].stringValue
        
        //  テーマ
        e.theme = json["theme"].stringValue
        
        //  イベントについて利用者が入力したデータの分類識別。
        e.tag = json["tag"].stringValue
        
        //  イベントタイトル
        e.title = json["title"].stringValue
        
        //  イベントの行い概要内容
        e.action = json["action"].stringValue
        
        //  イベント開始日時  ISO8601-YYYY-MM-DDTHH : mm : ssZ
        e.startDate = Date.bindDate(json["startDatetime"].stringValue)
        
        //  イベント終了日時
        e.endDate = Date.bindDate(json["endDatetime"].stringValue)
        
        //  時刻非表示フラグ。
        e.allDayFlag = json["allDayFlag"].boolValue
        
        //  島ID
        e.islandId = json["islandId"].stringValue
        
        //  該当イベントのLogoIdが指すContentsのLinkUrl
        e.eventLogoUrl = json["eventLogoUrl"].stringValue
        
        //  Gallery Id
        e.galleryId = json["galleryId"].stringValue
        
        //  会議番号
        e.meetingId = json["meetingId"].stringValue
        
        //  価格名称１
        e.priceName1 = json["priceName1"].stringValue
        
        //  価格額１
        e.price1 = json["price1"].stringValue
        
        //  価格名称2
        e.priceName2 = json["priceName2"].stringValue
        
        //  価格額２
        e.price2 = json["price2"].stringValue
        
        //  通貨　(USD,JPY,などISO通貨３桁表記)
        e.currency = json["currency"].stringValue
        
        //  価格について一般的な記述
        e.priceInfo = json["priceInfo"].stringValue
        
        //  イベントについて詳細な説明記述
        e.description = json["description"].stringValue
        
        //  連絡電話番号
        e.contactTel = json["contactTel"].stringValue
        
        //   連絡FAX
        e.contactFax = json["contactFax"].stringValue
        
        //   連絡メール
        e.contactMail = json["contactMail"].stringValue
        
        //   イベント公式ページURL
        e.officialUrl = json["officialUrl"].stringValue
        
        //   主催者の個人や団体の名称
        e.organizer = json["organizer"].stringValue
        
        //  情報源の名称
        e.sourceName = json["sourceName"].stringValue
        
        //  情報源のWebPageのURL
        e.sourceUrl = json["sourceUrl"].stringValue
        
        //  イベント参加方式、 OPEN：　自由参加、
        // INVITATION : 招待制、PRIVATE : 個人用、他の人は参加不可。
        e.participation = json["participation"].stringValue
        
        //  イベント情報のアクセス制御：　PUBLIC : 全公開、
        // PRIVATE : 非公開、 SHARED : 関係者のみ
        e.accessControl = json["accessControl"].stringValue
        
        //  いいねの数
        e.likes = json["likes"].stringValue
        
        // (M) 言語情報　(Ja_JP, en_US, en_GB) elasticsearchに使用する。
        e.language = json["language"].stringValue
        
        //  島情報
        //  isLandIdに結びつく島名称
        e.isLandName = json["isLandName"].stringValue
        
        //  該当island（島）のlogo_idが指すContentsのLinkURL
        e.isLandLogoUrl = json["isLandLogoUrl"].stringValue
        
        //  投稿者情報
        //  投稿者の名前
        e.publisherName = json["publisherName"].stringValue
        
        //  投稿者のアイコンのURL
        e.publisherIconUrl = json["publisherIconUrl"].stringValue
        
        //  何日たちましたか
        e.publishedDays = json["publishedDays"].stringValue
        
        //  加入情報　　ログイン中ユーザーが該当イベントを加入しているかどうかを示す。
        //  Participating/Watching/Notyet
        e.participationStatus = json["participationStatus"].boolValue
        
        //TODO: ActivityItemに該当ステータスを記録すべし

        return e
    }
}
