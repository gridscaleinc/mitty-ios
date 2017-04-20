//
//  Model.swift
//  mitty
//
//  Created by gridscale on 2016/10/30.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//

import Foundation

///
/// イベント情報
class Event {
    var    id : Int8 = 0
    var    type : String? = nil
    var    iconId: Int? = nil
    var    tag : String = ""
    var    title : String? = nil
    var    action : String? = nil
    var    tel : String? = nil
    var    fax : String? = nil
    var    mailaddress : String? = nil
    var    webpage : String? = nil
    var    startDateTime : String? = nil
    var    endDateTime : String? = nil
    var    alldayFlag : String? = nil
    var    limitOfApplications : String? = nil
    var    galleryId: Int? = nil
    var    gallery : [Gallery] = []
    var    islandId : Int? = nil
    var    island : Island? = nil
    var    meetingId : String? = nil
    var    priceName1 : String? = nil
    var    price1 : String? = nil
    var    priceName2 : String? = nil
    var    price2 : String? = nil
    var    priceCurrence : String? = nil
    var    priceInfo : String? = nil
    var    publisherId : String? = nil
    var    orgnizationId : String? = nil
    var    sourceName : String? = nil
    var    sourceUrl : String? = nil
    var    anticipants : String? = nil
    var    likes : Int? = 0
    var    status : String? = nil
    var    lastUpdated : String? = nil
    var    amenderId : Int? = nil
    
    init (_ id : Int8) {
        self.id = id
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
    
}

/// 連絡先
class SocialContactInfo {
    public var mittyId = ""
    public var imageUrl = ""
    public var name = ""
    
    
    
}

