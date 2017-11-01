//
//  ActivityInfo.swift
//  mitty
//
//  Created by gridscale on 2017/05/04.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

class ActivityInfo {
    var id: String = ""
    var title: String = ""
    var mainEventId: String? = nil
    var startDateTime: String = ""
    var logoUrl: String = ""
    var memo: String? = ""

    // main event　あるかどうかをチェック
    var hasEvent: Bool {
        if mainEventId == nil {
            return false
        } else if mainEventId == "" || mainEventId == "0" {
            return false
        } else {
            return true
        }

    }

    var monthDay: String {

        let dt = startDateTime.utc2Date()
        return dt.monthDay

    }
}

class Destination {
    var islandId: Int = 0 // -- island.id as island_id
    var islandNickName: String = "" // -- island.nickname as island_nickname,
    var islandName: String = "" // -- island.name as island_name,
    var latitude: Double = 0 // -- island.latitude,
    var longitude: Double = 0 // -- island.longitude,
    var islandLogo: String = "" // -- contents.link_url as island_logo,
    var eventId: Int = 0 // -- events.id as event_id,
    var eventLogo: String = ""
    var eventTitle: String = "" // -- events.title as event_title,
    var eventTime: Date = Date.nulldate // -- events.start_datetime as eventTime
}

class ActivityItem {
    var id: Int64 = 0
    var activityId: Int64 = 0
    var eventId: String = "0"
    var title: String = ""
    var memo: String = ""
    var notification: Bool = false
    var notificationTime: Date = .nulldate
    var eventTitle: String = ""
    var startDateTime: String = ""
    var endDateTime: String = ""
    var allDayFlag: Bool = false
    var eventLogoUrl: String = ""
    var islandName: String = ""
    var islandNickname: String = ""
    var islandLogoUrl: String = ""

    var start: String {
        let dt = startDateTime.utc2Date()
        if allDayFlag {
            return dt.monthDay
        } else {
            return dt.monthDay + " " + dt.time
        }
    }

    var notifyTime: String {
        if notification {
            let dt = notificationTime
            return dt.dateTime
        }
        return ""
    }
}

// 活動詳細
class Activity {
    var info: ActivityInfo = ActivityInfo()
    var items: [ActivityItem] = []
    var mainItem: ActivityItem? {
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
