//
//  NewEventReq.swift
//  mitty
//
//  Created by gridscale on 2017/04/28.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

class NewEventReq : JSONRequest {
    
    enum KeyNames : String {
        
        case type = "type"                   // (M)イベントの種類
        case tagList = "tag"                     // (M)イベントについて利用者が入力したデータの分類識別。
        case title = "title"                 // (M)イベントタイトル
        case action = "action"               // (M)イベントの行い概要内容
        case startDate = "startDate"         // (M)イベント開始日時
        case endDate = "endDate"             // (M)イベント終了日時
        case allDayFlag = "allDayFlag"       // (M)時刻非表示フラグ。
        case islandId = "islandId"           // (M)島ID   (Int)
        case priceName1 = "priceName1"       // (O)価格名称１
        case price1 = "price1"               // (O)価格額１ (Double)
        case priceName2 = "priceName2"       // (O)価格名称2
        case price2 = "price2"               // (O)価格額２ (Double)
        case currency = "currency"           //（O)通貨　(USD//JPY//などISO通貨３桁表記)
        case priceInfo = "priceInfo"         // (O)価格について一般的な記述
        case description = "description"     // (M)イベントについて詳細な説明記述
        case contactTel = "contactTel"       // (O)連絡電話番号
        case contactFax = "contactFax"       // (O)連絡FAX
        case contactMail = "contactMail"     // (O)連絡メール
        case officialUrl = "officialUrl"     // (O)イベント公式ページURL
        case organizer = "organizer"         // (O)主催者の個人や団体の名称
        case sourceName = "sourceName"       // (M)情報源の名称
        case sourceUrl = "sourceUrl"         // (O)情報源のWebPageのURL
        case anticipation = "anticipation"   // (O)イベント参加方式、 OPEN：　自由参加、
                                             //           INVITATION:招待制、PRIVATE:個人用、他の人は参加不可。
        case accessControl = "accessControl" // (O)イベント情報のアクセス制御：　PUBLIC: 全公開、　
                                             //   PRIVATE: 非公開、 SHARED:関係者のみ
        case language = "language"           // (M)言語情報　(Ja_JP, en_US, en_GB) elastic　searchに使用する。
        
        case relatedActivityId = "relatedActivityId"
        
        case asMainEvent = "asMainEvent"
    }
    
    func setStr(_ key: KeyNames, _ value: String?) {
        setStr(named: key.rawValue, value: value)
    }
    
    func setBool(_ key: KeyNames, _ value: Bool?) {
        setBool(named: key.rawValue, value: value!)
    }
    
    func setDate(_ key: KeyNames, _ value: Date?) {
        setDate(named: key.rawValue, date: value!)
    }
    
    func setInt(_ key: KeyNames, _ value: String) {
        setInt(named: key.rawValue, value: value)
    }
    
    func setDouble(_ key: KeyNames, _ value: String) {
        setDouble(named: key.rawValue, value: value)
    }
    
}
