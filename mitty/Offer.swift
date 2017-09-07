//
//  NamecardOffer.swift
//  mitty
//
//  Created by gridscale on 2017/09/01.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation


/// <#Description#>
class Offer {
    var id: Int64 = 0
    var fromMittyId : Int = 0
    var toMittyId: Int = 0
    var type: String = "NAMECARD"
    var message: String = ""
    var offerredId: Int64 = 0
    var repliedId: Int64 = 0
    var offerredDate: Date = .nulldate
    var repliedStatus: String = "NONE"
    
}
