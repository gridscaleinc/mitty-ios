//
//  Proposals.swift
//  mitty
//
//  Created by gridscale on 2017/08/12.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

// リクエスト情報
class ProposalInfo {

    var id: Int64 = 0
    var replyToRequestID: Int64 = 0
    var contactTel: String = ""
    var contactEmail: String = ""
    var proposedIslandID: Int64 = 0
    var proposedIslandID2: Int64 = 0
    var galleryID: Int64 = 0
    var priceName1: String = ""
    var price1: Int64 = 0
    var priceName2: String = ""
    var price2: Int64 = 0
    var priceCurrency: String = ""
    var priceInfo: String = ""
    var proposedDatetime1: Date = .nulldate
    var proposedDatetime2: Date = .nulldate
    var additionalInfo: String = ""
    var proposerId: Int = 0
    var proposerInfo: String = ""
    var confirmTel: String = ""
    var confirmEmail: String = ""
    
    var proposedDatetime : Date = .nulldate
    var acceptStatus : String  = ""
    var acceptDatetime : Date = .nulldate

    var approvalStatus: String = ""
    var approvalDate: Date = .nulldate
    
    // Propsal table 以外から
    var islandName: String = ""
    var proposerName: String = ""
    var proposerIconUrl: String = ""
    var numberOfLikes: Int = 0
    
    // 期間
    func term() -> String {
        return proposedDatetime1.monthDay + "〜" + proposedDatetime2.monthDay
    }
    
    // 価格
    func price() -> String {
        return price1Info() + price2Info()
    }

    func price1Info() -> String {
        if (price1 == 0) {
            return "未提示"
        } else {
            return priceName1 + " \(price1)" + priceCurrency
        }
        
    }
    
    func price2Info() -> String {
        if (price2 == 0) {
            return ""
        } else {
            return priceName2 + " \(price2)" + priceCurrency
        }
    }
    
    var isAcceptable : Bool {
        get {
            if acceptStatus == "NONE" && approvalStatus == "NONE" {
                return true
            }
            return false
        }
    }
    
    var isApprovable : Bool {
        get {
            if acceptStatus == "ACCEPTED" && approvalStatus == "NONE" {
                return true
            }
            return false
        }
    }
}
