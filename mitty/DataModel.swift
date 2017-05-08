//
//  Model.swift
//  mitty
//
//  Created by gridscale on 2016/10/30.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

///
/// イベント情報
class Event {
    
    //(O) PK イベントID
    var id : String
    
    //(M) イベントの種類
    var type: String? = nil
    
    //(O) カテゴリー
    var category: String? = nil
    
    //(O) テーマ
    var theme: String? = nil
    
    //(M) イベントについて利用者が入力したデータの分類識別。
    var tag:  String? = nil
    
    //(M) イベントタイトル
    var title: String? = nil
    
    //(M) イベントの行い概要内容
    var action: String? = nil
    
    //(M) イベント開始日時
    var startDate: String? = nil
    
    //(M) イベント終了日時
    var endDate: String? = nil
    
    //(M) 時刻非表示フラグ。
    var allDayFlag: String = "false"
    
    //(M) 島ID
    var islandId:  String? = nil
    
    var logoId: String? = nil
    
    var galleryId: String? = nil
    
    var meetingId: String? = nil
    
    //(O) 価格名称１
    var priceName1: String? = nil
    
    //(O) 価格額１
    var price1: String? = nil
    
    //(O) 価格名称2
    var priceName2: String?   = nil
    
    //(O) 価格額２
    var    price2: String?       = nil
    
    //(O) 通貨　(USD,JPY,などISO通貨３桁表記)
    var currency: String? = nil
    
    //(O) 価格について一般的な記述
    var priceInfo: String? = nil
    
    //(M) イベントについて詳細な説明記述
    var description: String? = nil
    
    //(O) 連絡電話番号
    var contactTel: String? = nil
    
    //(O) 連絡FAX
    var contactFax: String? = nil
    
    //(O) 連絡メール
    var contactMail: String? = nil
    
    //(O) イベント公式ページURL
    var officialUrl: String? = nil
    
    //(O) 主催者の個人や団体の名称
    var organizer: String? = nil
    
    //(M) 情報源の名称
    var sourceName: String? = nil
    
    //(O) 情報源のWebPageのURL
    var sourceUrl: String? = nil
    
    //(O) イベント参加方式、 OPEN：　自由参加、
    //    INVITATION:招待制、PRIVATE:個人用、他の人は参加不可。
    var anticipation: String? = nil
    
    //(M) イベント情報のアクセス制御：　PUBLIC: 全公開、
    //    PRIVATE: 非公開、 SHARED:関係者のみ
    var accessControl: String = "PRIVATE"
    
    var likes: Int? = nil
    
    var status: String = "DRAFT"
    
    //(M) 言語情報　(Ja_JP, en_US, en_GB) elasticsearchに使用する。
    var language: String = Locale.current.identifier
    
    init (_ id : Int) {
        self.id = String(id)
    }

    
    func duration() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        
        return "🕒" + startDate! + " - " + endDate!
    }
    
}


/// 島（グループ）
class Island {
    var     id : Int? = nil
    var     nickname : String? = nil
    var     name : String? = nil
    var     logoId : String? = nil
    var     description : String? = nil
    var     category : String? = nil
    var     mobilityType : String? = nil
    var     realityType : String? = nil
    var     ownershipType : String? = nil
    var     ownerName : String? = nil
    var     ownerId : String? = nil
    var     creatorId : String? = nil
    var     meetingId : String? = nil
    var     galleryId : String? = nil
    var     tel : String? = nil
    var     fax : String? = nil
    var     mailaddress : String? = nil
    var     webpage : String? = nil
    var     likes : String? = nil
    var     countryCode : String? = nil
    var     countryName : String? = nil
    var     state : String? = nil
    var     city : String? = nil
    var     postcode : String? = nil
    var     thoroghfare : String? = nil
    var     subthroghfare : String? = nil
    var     buildingName : String? = nil
    var     floorNumber : String? = nil
    var     roomNumber : String? = nil
    var     address1 : String? = nil
    var     address2 : String? = nil
    var     address3 : String? = nil
    var     latitude : String? = nil
    var     longitude : String? = nil
}

class Gallery {
    var id : Int8
    var seq : Int
    var caption : String? = nil
    var briefInfo : String? = nil
    var url : String? = nil
    var contentId: Int8? = nil
    var content : Content? = nil
    var freeText : String? = nil
    
    init(_ id: Int8, _ seq: Int) {
        self.id = id
        self.seq = seq
    }
}

class Content {
    var id : Int8
    var mime : String? = nil
    var title : String? = nil
    var linkUrl : String? = nil
    var width : Int? = nil
    var height : Int? = nil
    var data : [UInt8] = []
    var size : Int? = nil
    
    init(_ id: Int8) {
        self.id = id
    }
}

/// 発言
class Talk {
    
    public var mittyId = ""
    public var avatarIcon = ""
    public var familyName = ""
    public var speaking = ""
    
    public var height = CGFloat(0.0)
    
    
}

/// 連絡先
class SocialContactInfo {
    public var mittyId = ""
    public var imageUrl = ""
    public var name = ""
}

