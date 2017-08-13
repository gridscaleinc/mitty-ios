//
//  NewRequestReq.swift
//  mitty
//
//  Created by gridscale on 2017/06/12.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

class NewRequestReq: JSONRequest {

    enum KeyNames: String {

        // (M)  イベントについて利用者が入力したデータの分類識別。
        case tagList = "tag"
        
        // (M)  イベントタイトル
        case title = "title"
        
        // (M)  イベントについて詳細な説明記述
        case description = "description"
        
        // (O)  関連活動ID
        case forActivityId = "forActivityId"
        
        // (O)  希望日時１
        case preferredDatetime1 = "preferredDatetime1"
        
        // (O)  希望日時２
        case preferredDatetime2 = "preferredDatetime2"

        // (O)  希望価格１
        case preferredPrice1 = "preferredPrice1"
        
        // (O)  希望価格２
        case preferredPrice2 = "preferredPrice2"

        // (O)  開始場所名
        case startPlace = "startPlace"
        
        // (O)  終了場所名
        case terminatePlace = "terminatePlace"

        // (O)  片道フラグ
        case oneway = "oneway"
        
        // (O)  締め切り日
        case expiryDate = "expiryDate"

        // (O)  締め切り日
        case numOfPerson = "numOfPerson"
        
        // (O)  締め切り日
        case numOfChildren = "numOfChildren"
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
