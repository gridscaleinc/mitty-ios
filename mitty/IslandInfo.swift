//
//  IslandInfo.swift
//  mitty
//
//  Created by gridscale on 2017/04/22.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import MapKit

class IslandPick {
    
    var id : Int = 0
    var iconUrl : String?
    var name : String?
    var nickName : String?
    var address : String?
    
    var placeMark: CLPlacemark?
    
}

class IslandInfo {
    var nickname   : String = ""      // (O)  愛称
    var name       : String = ""      // (M)  名称
    var logoUrl    : String = ""      // 該当 島のLogoIdに紐つくContentのURL
    var address1   : String = ""      // (O)  住所行１
    var address2   : String = ""      // (O)  住所行２
    var address3   : String = ""      // (O)  住所行３
    var latitude   : Double = 0       // (O)  地理位置の緯度
    var longitude  : Double = 0       // (O)  地理位置の経度
    var meetingId  : Int64  = 0       // (O)  会議室の番号
}
