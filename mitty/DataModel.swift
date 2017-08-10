//
//  Model.swift
//  mitty
//
//  Created by gridscale on 2016/10/30.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit


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
    var id : Int64 = 0
    var mime : String? = nil
    var title : String? = nil
    var linkUrl : String? = nil
    var width : Int? = nil
    var height : Int? = nil
    var data : [UInt8] = []
    var size : Int? = nil
}

/// 発言
class Talk {
    
    var meetingId : Int64 = 0
    var speakerId : Int64 = 0
    var speaking = ""
    var speakTime = Date.nulldate
    
    var height = CGFloat(0.0)
    
    
}

/// 連絡先
class SocialContactInfo {
    public var mittyId = ""
    public var imageUrl = ""
    public var name = ""
}

