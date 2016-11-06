//
//  EventService.swift
//  mitty
//
//  Created by gridscale on 2016/11/06.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//

import Foundation


// シングルトンサービスクラス。
class EventService {
    static var instance : EventService = {
        let instance = EventService()
        return instance
    }()
    
    private init() {
        
    }

    // サーバーからイベントを検索。
    func search(keys : [String]) -> [Event] {
        
        // ダミーコード、本当はサーバーから検索する。
        var events = [Event]()
        events.append(buildEvent(1))
        events.append(buildEvent(2))
        events.append(buildEvent(3))
        events.append(buildEvent(4))
        events.append(buildEvent(5))
        
        return events
        
    }

    // イベントを生成する
    func buildEvent(_ n:Int) ->Event! {
        
        let imagenames: [String] = ["event1","event2","event3","event4","event5","event6"]
        
        let a = Event()
        
        a.eventId = "id" + String(n)
        a.title = "title" + String(n)
        a.price  = 10 * n
        a.imageUrl = imagenames[n-1]
        a.startDate = "2016-09-09"
        a.endDate = "2016-10-10"
        a.startTime = "12:30"
        a.endTime = "16:30"
        
        a.likes = 10+n
        
        a.endTime = "12:34:56"
        
        return a;
    }

}
