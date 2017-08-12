//
//  NewRequestReq.swift
//  mitty
//
//  Created by gridscale on 2017/06/12.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

class NewRequestReq : JSONRequest {
    
    enum KeyNames : String {
        
        case tagList = "tag"                             // (M)  イベントについて利用者が入力したデータの分類識別。
        case title = "title"                             // (M)  イベントタイトル
        case description = "description"                 // (M)  イベントについて詳細な説明記述
        case forActivityId = "forActivityId"             // (O)  関連活動ID
        case preferredDatetime1 = "preferredDatetime1"   // (O)  希望日時１
        case preferredDatetime2 = "preferredDatetime2"   // (O)  希望日時２
        
        case preferredPrice1 = "preferredPrice1"         // (O)  希望価格１
        case preferredPrice2 = "preferredPrice2"         // (O)  希望価格２
        
        case startPlace      = "startPlace"              // (O)  開始場所名
        case terminatePlace  = "terminatePlace"          // (O)  終了場所名
        
        case oneway  = "oneway"                          // (O)  片道フラグ
        case expiryDate  = "expiryDate"                  // (O)  締め切り日
        
        case numOfPerson  = "numOfPerson"                // (O)  締め切り日
        case numOfChildren  = "numOfChildren"            // (O)  締め切り日
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
