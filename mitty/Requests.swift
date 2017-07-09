//
//  Requests.swift
//  mitty
//
//  Created by gridscale on 2017/07/06.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

class RequestInfo  {
    var id : Int64 = 0
    var title : String = ""
    var tag : String = ""
    var desc : String = ""
    var forActivityId : Int64 = 0
    var preferredDatetime1 : Date = .nulldate
    var preferredDatetime2 : Date = .nulldate
    var preferredPrice1 : Int64 = 0
    var preferredPrice2 : Int64 = 0
    var startPlace  : String = ""
    var terminatePlace : String = ""
    var oneway : String = ""
    var status : String = ""
    var expiryDate : Date = .nulldate
    var numOfPerson : Int = 0
    var numOfChildren : Int = 0
    var acceptedProposalId : Int64 = 0
    var acceptedDate : Date = .nulldate
    var meetingId : Int64 = 0
    var ownerId : Int64 = 0
    var created : Date = .nulldate
    var updated : Date = .nulldate
    
    // 希望期間
    func term() -> String {
        return preferredDatetime1.monthDay + "〜" + preferredDatetime1.monthDay
    }
    
    // 希望期間
    func price() -> String {
        return String(preferredPrice1) + "〜" + String(preferredPrice2) + "円"
    }
    
    // 人数
    func nop() -> String {
        return "大人 " + String(numOfPerson) + "人、 子供 " + String(numOfChildren) + "人"
    }
    
    //
    func requestDays() -> String {
        if (created == Date.nulldate) {
            return ""
        }
        
        return  String(Int(Date().timeIntervalSince(created) / 83640)) + " Days"
    }
}
