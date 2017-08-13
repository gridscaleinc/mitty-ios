//
//  NewIslandReq.swift
//  mitty
//
//  Created by gridscale on 2017/05/09.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

class NewIslandReq: JSONRequest {

    enum KeyNames: String {
        //nickname   : string              --(O)  愛称
        case nickname = "nickname"
        
        //name               : string      --(M)  名称
        case name = "name"
        
        //logoId             : int         --(O)  LogoのContent Id
        case logoId = "logoId"
        
        //description        : string      --(O)  説明
        case description = "description"
        
        //category           : string      --(M)  カテゴリ
        case category = "category"
        
        //mobilityType       : string      --(M)  移動性分類
        case mobilityTyep = "mobilityType"
        
        //realityType        : string      --(M)  実在性分類
        case realityType = "realityType"
        
        //ownershipType      : string      --(M)  所有者分類
        case ownershipTYpe = "ownershipType"
        
        //ownerName          : string      --(O)  所有者名
        case ownerName = "ownerName"
        
        //ownerId            : int         --(O)  所有者のMitty User Id
        case ownerId = "ownerId"
        
        //creatorId          : int         --(O)  作成者のMitty User Id
        case creatorId = "creatorId"
        
        //meetingId          : int         --(O)  会議Id
        case meetingId = "meetingId"
        
        //galleryId          : int         --(O)  ギャラリーID
        case galleryId = "galleryId"
        
        //tel                : string      --(O)  電話番号
        case tel = "tel"
        
        //fax                : string      --(O)  FAX
        case fax = "fax"
        
        //mailaddress        : string      --(O)  メールアドレス
        case mailaddress = "mailaddress"
        
        //webpage            : string      --(O) 　WebページのURL
        case webpage = "webpage"
        
        //likes              : string      --(O)  いいねの数
        case likes = "likes"
        
        //countryCode        : string      --(O)  国コード
        case countryCode = "countryCode"
        
        //countryName        : string      --(O)  国名称
        case countryName = "countryName"
        
        //state              : string      --(O)  都道府県
        case state = "state"
        
        //city               : string      --(O)  市、区
        case city = "city"
        
        //postcode           : string      --(O)  郵便番号
        case postcode = "postcode"
        
        //thoroghfare        : string      --(O)  大通り
        case thoroghfare = "thoroghfare"
        
        //subthroghfare      : string      --(O)  通り
        case subthorghfare = "subthroghfare"
        
        //buildingName       : string      --(O)  建物名称
        case buildingName = "buildingName"
        
        //floorNumber        : string      --(O)  フロー番号
        case floorNumber = "floorNumber"
        
        //roomNumber         : string      --(O)  部屋番号
        case roomNumber = "roomNumber"
        
        //address1           : string      --(O)  住所行１
        case address1 = "address1"
        
        //address2           : string      --(O)  住所行２
        case address2 = "address2"
        
        //address3           : string      --(O)  住所行３
        case address3 = "address3"
        
        //latitude           : double      --(O)  地理位置の緯度
        case latitude = "latitude"
        
        //longitude          : double      --(O)  地理位置の経度
        case longitude = "longitude"
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
