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
    
    var mainEventId : Int64? = nil
    
    var mainItem : ActivityItemInfo? = nil
    
    var startDateTime : String = ""

    var logoUrl : String = ""
    
    var memo: String? = ""
    var activityItems : [ActivityItemInfo] = []
    
    func dummy() -> ActivityInfo {
        
        let info = ActivityInfo()
        info.title = "新年の鐘を聞きに行く"
        info.mainEventId=123
        info.memo = "休みを取ることは忘れなく。引き継ぎ事情もあるかもしれないから、早めにリーダに相談する。航空券、ホテル。。。。"
        let main = ActivityItemInfo()
        main.title = "ニューヨークタイムスクエア　New year count down！"
        info.mainItem = main
        for i in 0...5 {
            let itemInfo = ActivityItemInfo()
            itemInfo.title = "イベントタイトル"
            if ( i == 3) {
                itemInfo.notification = 1
                itemInfo.notificationTime = "2017/8/19 12:34"
                info.activityItems.append(itemInfo)
            }
        }
        return info
    }
}

class ActivityItemInfo {
    var activityId : String = ""
    var title : String = "ニューヨークに行きたい"
    var memo : String = ""
    var notification : Int = 0
    var notificationTime : String = "2017/8/19 12:34"
    var eventIcon : String = "timesquare"
    var location = "ニューヨークタイムスクエア"
    var locationIcon : String = "timesquare"
}
