//
//  Event.swift
//  mitty
//
//  Created by gridscale on 2017/05/13.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

///
/// イベント情報
class EventInfo {
    
    //  イベント情報
    var id : String = ""
    
    // イベントタイトル
    var title : String = ""
    
    // イベントの行い概要内容
    var action : String = ""
    
    // イベント開始日時  ISO8601-YYYY-MM-DDTHH : mm : ssZ
    var startDate : String = ""
    
    // イベント終了日時　ISO8601-YYYY-MM-DDTHH : mm : ssZ
    var endDate : String = ""
    
    // 時刻非表示フラグ。
    var allDayFlag : Bool = false
    
    // 該当イベントのLogoIdが指すContentsのLinkUrl
    var eventLogoUrl : String = ""
    
    // galleryId<>Nullの場合、該当GalleryId, Seq=1のコンテンツ
    // のLinkUrl
    
    var imageUrl : String = ""
    
    // 価格名称１
    var priceName1 : String = ""
    
    // 価格額１
    var price1 : String = ""
    
    // 価格名称2
    var priceName2 : String = ""
    
    // 価格額２
    var price2 : String = ""
    
    // 通貨　(USD,JPY,などISO通貨３桁表記)
    var currency : String = ""
    
    // 価格について一般的な記述
    var priceInfo : String = ""
    
    //   イベント参加方式、 OPEN：　自由参加、
    //    INVITATION : 招待制、PRIVATE : 個人用、他の人は参加不可。
    var participation : String = ""
    
    //     イベント情報のアクセス制御：　PUBLIC : 全公開、
    //    PRIVATE : 非公開、 SHARED : 関係者のみ
    var accessControl : String = ""
    
    //   いいねの数
    var likes : String = ""
    
    // 島情報
    // isLandIdに結びつく島名称
    var islandName : String = ""
    
    // 該当island（島）のlogo_idが指すContentsのLinkURL
    var islandLogoUrl : String = ""
    
    //  投稿者情報
    // 投稿者の名前
    var publisherName : String = ""
    
    // 投稿者のアイコンのURL
    var publisherIconUrl : String = ""
    
    // 何日たちましたか
    var publishedDays : String = ""
    
    func duration() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        
        return "🕒" + startDate + " - " + endDate
    }
    
}


class Event {
    //  イベント情報
    
    var id : String = ""
    
    //  イベントの種類
    var type : String = ""
    
    //  カテゴリー
    var category : String = ""
    
    //  テーマ
    var theme : String = ""
    
    //  イベントについて利用者が入力したデータの分類識別。
    var tag : String = ""
    
    //  イベントタイトル
    var title : String = ""
    
    //  イベントの行い概要内容
    var action : String = ""
    
    //  イベント開始日時  ISO8601-YYYY-MM-DDTHH : mm : ssZ
    var startDate : String = ""
    
    //  イベント終了日時
    var endDate : String = ""
    
    //  時刻非表示フラグ。
    var allDayFlag : Bool = false
    
    //  島ID
    var islandId : String = ""
    
    //  該当イベントのLogoIdが指すContentsのLinkUrl
    var eventLogoUrl : String = ""
    
    //  Gallery Id
    var galleryId : String = ""
    
    //  会議番号
    var meetingId : String = ""
    
    //  価格名称１
    var priceName1 : String = ""
    
    //  価格額１
    var price1 : String = ""
    
    //  価格名称2
    var priceName2 : String = ""
    
    //  価格額２
    var price2 : String = ""
    
    //  通貨　(USD,JPY,などISO通貨３桁表記)
    var currency : String = ""
    
    //  価格について一般的な記述
    var priceInfo : String = ""
    
    //  イベントについて詳細な説明記述
    var description : String = ""
    
    //  連絡電話番号
    var contactTel : String = ""
    
    //   連絡FAX
    var contactFax : String = ""
    
    //   連絡メール
    var contactMail : String = ""
    
    //   イベント公式ページURL
    var officialUrl : String = ""
    
    //   主催者の個人や団体の名称
    var organizer : String = ""
    
    //  情報源の名称
    var sourceName : String = ""
    
    //  情報源のWebPageのURL
    var sourceUrl : String = ""
    
    //  イベント参加方式、 OPEN：　自由参加、
    // INVITATION : 招待制、PRIVATE : 個人用、他の人は参加不可。
    var participation : String = ""
    
    //  イベント情報のアクセス制御：　PUBLIC : 全公開、
    // PRIVATE : 非公開、 SHARED : 関係者のみ
    var accessControl : String = ""
    
    //  いいねの数
    var likes : String = ""
    
    // (M) 言語情報　(Ja_JP, en_US, en_GB) elasticsearchに使用する。
    var language : String = ""
    
    //  島情報
    //  isLandIdに結びつく島名称
    var isLandName : String = ""
    
    //  該当island（島）のlogo_idが指すContentsのLinkURL
    var isLandLogoUrl : String = ""
    
    //  投稿者情報
    //  投稿者の名前
    var publisherName : String = ""
    
    //  投稿者のアイコンのURL
    var publisherIconUrl : String = ""
    
    //  何日たちましたか
    var publishedDays : String = ""
    
    //  加入情報　　ログイン中ユーザーが該当イベントを加入しているかどうかを示す。
    //  Participating/Watching/Notyet
    var participationStatus : String = ""
    
    func duration() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        
        return "🕒" + startDate + " - " + endDate
    }
}
