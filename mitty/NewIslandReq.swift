//
//  NewIslandReq.swift
//  mitty
//
//  Created by gridscale on 2017/05/09.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

class NewIslandReq : JSONRequest {
    
    enum KeyNames : String {
        case nickname = "nickname"             //nickname           : string      --(O)  愛称
        case name = "name"                     //name               : string      --(M)  名称
        case logoId = "logoId"                 //logoId             : int         --(O)  LogoのContent Id
        case description = "description"       //description        : string      --(O)  説明
        case category = "category"             //category           : string      --(M)  カテゴリ
        case mobilityTyep = "mobilityType"     //mobilityType       : string      --(M)  移動性分類
        case realityType = "realityType"       //realityType        : string      --(M)  実在性分類
        case ownershipTYpe = "ownershipType"   //ownershipType      : string      --(M)  所有者分類
        case ownerName = "ownerName"           //ownerName          : string      --(O)  所有者名
        case ownerId = "ownerId"               //ownerId            : int         --(O)  所有者のMitty User Id
        case creatorId = "creatorId"           //creatorId          : int         --(O)  作成者のMitty User Id
        case meetingId = "meetingId"           //meetingId          : int         --(O)  会議Id
        case galleryId = "galleryId"           //galleryId          : int         --(O)  ギャラリーID
        case tel = "tel"                       //tel                : string      --(O)  電話番号
        case fax = "fax"                       //fax                : string      --(O)  FAX
        case mailaddress = "mailaddress"       //mailaddress        : string      --(O)  メールアドレス
        case webpage = "webpage"               //webpage            : string      --(O) 　WebページのURL
        case likes = "likes"                   //likes              : string      --(O)  いいねの数
        case countryCode = "countryCode"       //countryCode        : string      --(O)  国コード
        case countryName = "countryName"       //countryName        : string      --(O)  国名称
        case state = "state"                   //state              : string      --(O)  都道府県
        case city = "city"                     //city               : string      --(O)  市、区
        case postcode = "postcode"             //postcode           : string      --(O)  郵便番号
        case thoroghfare = "thoroghfare"       //thoroghfare        : string      --(O)  大通り
        case subthorghfare = "subthroghfare"   //subthroghfare      : string      --(O)  通り
        case buildingName = "buildingName"     //buildingName       : string      --(O)  建物名称
        case floorNumber = "floorNumber"       //floorNumber        : string      --(O)  フロー番号
        case roomNumber = "roomNumber"         //roomNumber         : string      --(O)  部屋番号
        case address1 = "address1"             //address1           : string      --(O)  住所行１
        case address2 = "address2"             //address2           : string      --(O)  住所行２
        case address3 = "address3"             //address3           : string      --(O)  住所行３
        case latitude = "latitude"             //latitude           : double      --(O)  地理位置の緯度
        case longitude = "longitude"           //longitude          : double      --(O)  地理位置の経度
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
