//
//  ActivityInfo.swift
//  mitty
//
//  Created by gridscale on 2017/05/04.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

class ActivityInfo {
    var id : String = ""
    var title : String = "ニューヨークに行きたい"
    var mainEventId : String? = nil
    var startDateTime : String = ""
    var logoUrl : String = ""
    var memo: String? = ""
}

class ActivityItem {
    var eventId: String = "0"
    var title: String = ""
    var memo: String = ""
    var notification: String  = ""
    var notificationTime: String  = ""
    var eventTitle:String  = ""
    var startDateTime: String  = ""
    var endDateTime: String  = ""
    var allDayFlag: Bool  = false
    var eventLogoUrl : String  = ""
}

// 活動詳細
class Activity {
    var info: ActivityInfo = ActivityInfo()
    var items: [ActivityItem] = []
 }
