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
    let urlBase = "http://dev.mitty.co/api/search/event"
    
    static var instance : EventService = {
        let instance = EventService()
        return instance
    }()
    
    var images = ["event1", "event6", "event4","event10","event5"]
    
    private init() {
        
    }

    // サーバーからイベントを検索。
    func search(keys : String, callback: @escaping (_ events: [Event]) -> Void ) {
        let parmeters = [
            "q" : keys
        ]
        
        // ダミーコード、本当はサーバーから検索する。
        var events = [Event]()
        let request = Alamofire.request(urlBase, method: .get, parameters: parmeters)
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
                        events.append(self.bindEvent(jsonEvent))
                    }
                }
                
                callback(events)
                
            case .failure(let error):
                LoadingProxy.off()
                print(error)
            }
        }
    }

    func bindEvent(_ jsEvent: JSON) -> Event {
        let id = jsEvent["id"].int
        let e = Event(id!)
        
        //(M) イベントの種類
        e.type = jsEvent["type"].stringValue
        
        //(O) カテゴリー
        e.category = jsEvent["category"].stringValue
        
        //(O) テーマ
        e.theme = jsEvent["theme"].stringValue
        
        //(M) イベントについて利用者が入力したデータの分類識別。
        e.tag = jsEvent["tag"].stringValue
        
        //(M) イベントタイトル
        e.title = jsEvent["title"].stringValue
        
        //(M) イベントの行い概要内容
        e.action = jsEvent["action"].stringValue
        
        //(M) イベント開始日時
        e.startDate = jsEvent["start_datetime"].stringValue
        
        //(M) イベント終了日時
        e.endDate = jsEvent["end_datetime"].stringValue
        
        //(M) 時刻非表示フラグ。
        e.allDayFlag = jsEvent["allday_flag"].stringValue
        
        //(M) 島ID
        e.islandId = jsEvent["islandId"].stringValue
        
        e.logoId = jsEvent["logo_id"].stringValue
        
        e.galleryId = jsEvent["gallery_id"].stringValue
        
        e.meetingId = jsEvent["meetingId"].stringValue
        
        //(O) 価格名称１
        e.priceName1 = jsEvent["price_name1"].stringValue
        
        //(O) 価格額１
        e.price1 = jsEvent["price1"].stringValue
        
        //(O) 価格名称2
        e.priceName2 = jsEvent["price_name2"].stringValue
        
        //(O) 価格額２
        e.price2 = jsEvent["price2"].stringValue
        
        //(O) 通貨　(USD,JPY,などISO通貨３桁表記)
        e.currency = jsEvent["currency"].stringValue
        
        //(O) 価格について一般的な記述
        e.priceInfo = jsEvent["price_info"].stringValue
        
        //(M) イベントについて詳細な説明記述
        e.description = jsEvent["description"].stringValue
        
        //(O) 連絡電話番号
        e.contactTel = jsEvent["contact_tel"].stringValue
        
        //(O) 連絡FAX
        e.contactFax = jsEvent["contact_fax"].stringValue
        
        //(O) 連絡メール
        e.contactMail = jsEvent["contact_mail"].stringValue
        
        //(O) イベント公式ページURL
        e.officialUrl = jsEvent["official_url"].stringValue
        
        //(O) 主催者の個人や団体の名称
        e.organizer = jsEvent["organizer"].stringValue
        
        //(M) 情報源の名称
        e.sourceName = jsEvent["source_name"].stringValue
        
        //(O) 情報源のWebPageのURL
        e.sourceUrl = jsEvent["source_url"].stringValue
        
        //(O) イベント参加方式、 OPEN：　自由参加、
        //    INVITATION:招待制、PRIVATE:個人用、他の人は参加不可。
        e.anticipation = jsEvent["anticipation"].stringValue
        
        //(M) イベント情報のアクセス制御：　PUBLIC: 全公開、
        //    PRIVATE: 非公開、 SHARED:関係者のみ
        e.accessControl = jsEvent["access_control"].stringValue
        
        e.likes = jsEvent["likes"].int
        e.status = jsEvent["status"].stringValue
        
        //(M) 言語情報　(Ja_JP, en_US, en_GB) elasticsearchに使用する。
        e.language = jsEvent["language"].stringValue

        return e
    }
    
    // イベントを生成する
    func buildEvent(_ n:Int) ->Event! {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let a = Event(n)
        a.title = "title" + String(n)
        a.priceInfo  = "\(10 * n)"

        a.startDate = "2016-10-10 12:12:12"
        a.endDate = "2016-10-10 12:12:12"
        
        
        a.likes = 10 + n
        
        return a;
    }

}
