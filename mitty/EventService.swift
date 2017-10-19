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
import AlamofireImage

import SwiftyJSON

// シングルトンサービスクラス。
class EventService: Service {
    static var instance: EventService = {
        let instance = EventService()
        return instance
    }()

    var images = ["event1", "event6", "event4", "event10", "event5"]

    private override init() {

    }

    // サーバーからイベントを検索。
    /// Google検索のように、キーワードよりイベント一覧を検索。
    /// TODO: Paging未対応。
    ///
    /// - Parameters:
    ///   - keys: 検索キー
    ///   - callback: コールバック。
    func search(keys: String, callback: @escaping (_ events: [EventInfo]) -> Void) {
        let parameters = [
            "q": keys
        ]

        LoadingProxy.on()

        // ダミーコード、本当はサーバーから検索する。
        var events = [EventInfo]()
        
        let api = APIClient(path: "/search/event", method: .get, parameters: parameters)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            if (json == nil || json["events"] == nil) {
                callback([])
                return
            }
            for (_, jsonEvent) in json["events"] {
                events.append(self.bindEventInfo(jsonEvent))
            }
            callback(events)
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })

    }

    
    /// イベント情報バインド。
    ///
    /// - Parameter jsEvent: JSONオブジェクト。
    /// - Returns: イベント及び附属情報オブジェクト。
    func bindEventInfo(_ jsEvent: JSON) -> EventInfo {

        let e = EventInfo()

        print(jsEvent)
        //  イベント情報
        e.id = jsEvent["id"].stringValue
        e.title = jsEvent["title"].stringValue // イベントタイトル
        e.action = jsEvent["action"].stringValue // イベントの行い概要内容
        e.startDate = jsEvent["startDatetime"].stringValue.utc2Date()
        // イベント開始日時  ISO8601-YYYY-MM-DDTHH:mm:ssZ
        e.endDate = jsEvent["endDatetime"].stringValue.utc2Date()
        // イベント終了日時　ISO8601-YYYY-MM-DDTHH:mm:ssZ
        e.allDayFlag = jsEvent["allDayFlag"].boolValue // 時刻非表示フラグ。
        e.eventLogoUrl = jsEvent["eventLogoUrl"].stringValue // 該当イベントのLogoIdが指すContentsのLinkUrl
        e.coverImageUrl = jsEvent["coverImageUrl"].stringValue // galleryId<>Nullの場合、該当GalleryId, Seq=1のコンテンツ
        // のLinkUrl
        e.priceName1 = jsEvent["priceName1"].stringValue // 価格名称１
        e.price1 = jsEvent["price1"].stringValue // 価格額１
        e.priceName2 = jsEvent["priceName2"].stringValue // 価格名称2
        e.price2 = jsEvent["price2"].stringValue // 価格額２
        e.currency = jsEvent["currency"].stringValue // 通貨　(USD,JPY,などISO通貨３桁表記)
        e.priceInfo = jsEvent["priceInfo"].stringValue // 価格について一般的な記述
        e.participation = jsEvent["participation"].stringValue //   イベント参加方式、 OPEN：　自由参加、
        //    INVITATION:招待制、PRIVATE:個人用、他の人は参加不可。
        e.accessControl = jsEvent["accessControl"].stringValue //     イベント情報のアクセス制御：　PUBLIC: 全公開、
        //    PRIVATE: 非公開、 SHARED:関係者のみ
        e.likes = jsEvent["numberOfLikes"].intValue //   いいねの数

        // 島情報
        e.islandName = jsEvent["islandName"].stringValue // isLandIdに結びつく島名称
        e.islandLogoUrl = jsEvent["islandLogoUrl"].stringValue // 該当island（島）のlogo_idが指すContentsのLinkURL

        e.latitude = jsEvent["latitude"].doubleValue
        e.longitude = jsEvent["longitude"].doubleValue
        //  投稿者情報
        e.publisherName = jsEvent["publisherName"].stringValue // 投稿者の名前
        e.publisherIconUrl = jsEvent["publisherIconUrl"].stringValue // 投稿者のアイコンのURL
        e.publishedDays = jsEvent["publishedDays"].stringValue // 何日たちましたか

        return e
    }

    
    /// イベント取得。
    ///
    /// - Parameters:
    ///   - id: イベントID
    ///   - callback: コールバック。
    func fetch(id: String, callback: @escaping (Event) -> Void) {
        let parameters = [
            "id": id
        ]

        LoadingProxy.on()

        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]

        // ダミーコード、本当はサーバーから検索する。
        let api = APIClient(path: "/event/of", method: .get, parameters: parameters, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            let event = self.bindEvent(json)
            callback(event)
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })

    }

    /// イベントオブジエクトバインド。
    ///
    /// - Parameter json: JSONオブジェクト。
    /// - Returns: エベントオブジェクト。
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
        e.startDate = json["startDatetime"].stringValue.utc2Date()

        //  イベント終了日時
        e.endDate = json["endDatetime"].stringValue.utc2Date()

        //  時刻非表示フラグ。
        e.allDayFlag = json["allDayFlag"].boolValue

        //  島ID
        e.islandId = json["islandId"].stringValue

        //  該当イベントのCoverImage指すContentsのLinkUrl
        e.coverImageUrl = json["coverImageUrl"].stringValue


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
        e.likes = json["numberOfLikes"].intValue

        // (M) 言語情報　(Ja_JP, en_US, en_GB) elasticsearchに使用する。
        e.language = json["language"].stringValue

        //  島情報
        //  isLandIdに結びつく島名称
        e.isLandName = json["isLandName"].stringValue

        //  該当island（島）のlogo_idが指すContentsのLinkURL
        e.isLandLogoUrl = json["isLandLogoUrl"].stringValue

        e.latitude = json["latitude"].doubleValue

        e.longitude = json["longitude"].doubleValue

        //  投稿者情報
        //  投稿者の名前
        e.publisherId = json["publisherId"].intValue
        e.publisherName = json["publisherName"].stringValue

        //  投稿者のアイコンのURL
        e.publisherIconUrl = json["publisherIconUrl"].stringValue

        //  何日たちましたか
        e.publishedDays = json["publishedDays"].stringValue

        //  加入情報　　ログイン中ユーザーが該当イベントを加入しているかどうかを示す。
        //  Participating/Watching/Notyet
        e.participationStatus = json["participationStatus"].stringValue

        //TODO: ActivityItemに該当ステータスを記録すべし

        return e
    }

    func loadImages (_ e: EventInfo) {
        DataRequest.addAcceptableImageContentTypes(["binary/octet-stream"])
        if e.coverImageUrl != "" && e.coverImage == nil {
            Alamofire.request(e.coverImageUrl).validate(statusCode: 200..<300).responseImage {
                response in
                self.debugInfo(response)
                if let image = response.result.value {
                    e.coverImage = image
                    if e.isDataReady {
                        e.dataReadyHandler()
                    }
                }
            }
        }

        if e.eventLogoUrl != "" && e.eventLogo == nil {
            Alamofire.request(e.eventLogoUrl).validate(statusCode: 200..<300).responseImage {
                response in
                self.debugInfo(response)
                if let image = response.result.value {
                    e.eventLogo = image
                    if e.isDataReady {
                        e.dataReadyHandler()
                    }
                }

            }
        }

        if e.islandLogoUrl != "" && e.islandLogo == nil {
            Alamofire.request(e.islandLogoUrl).validate(statusCode: 200..<300).responseImage {
                response in
                self.debugInfo(response)
                if let image = response.result.value {
                    e.islandLogo = image
                    if e.isDataReady {
                        e.dataReadyHandler()
                    }
                }
            }
        }

        if e.publisherIconUrl != "" {
            Alamofire.request(e.publisherIconUrl).validate(statusCode: 200..<300).responseImage {
                response in
                self.debugInfo(response)
                if let image = response.result.value {
                    e.publisherIcon = image
                    if e.isDataReady {
                        e.dataReadyHandler()
                    }
                }
            }
        }
    }


    func debugInfo(_ response: DataResponse<Image>?) {
        debugPrint(response ?? "no response")
        print(response?.request ?? "null request")
        print(response?.response ?? "null response")
        debugPrint(response?.result ?? "no result")
    }
}
