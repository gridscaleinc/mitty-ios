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
    var title : String = ""
    var mainEventId : String? = nil
    var startDateTime : String = ""
    var logoUrl : String = ""
    var memo: String? = ""
}

class ActivityItem {
    var eventId: String = "0"
    var title: String = ""
    var memo: String = ""
    var notification: Bool  = false
    var notificationTime: String  = ""
    var eventTitle:String  = ""
    var startDateTime: String  = ""
    var endDateTime: String  = ""
    var allDayFlag: Bool  = false
    var eventLogoUrl : String  = ""
    var islandName : String  = ""
    var islandNickname : String  = ""
    var islandLogoUrl : String  = ""
}

// 活動詳細
class Activity {
    var info: ActivityInfo = ActivityInfo()
    var items: [ActivityItem] = []
    var mainItem : ActivityItem? {
        get {
            for item in items {
                if item.eventId == info.mainEventId {
                    return item
                }
            }
            return ActivityItem()
        }
    }
 }
