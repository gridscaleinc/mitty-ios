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
}
