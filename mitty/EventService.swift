//
//  EventService.swift
//  mitty
//
//  Created by gridscale on 2016/11/06.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit


// シングルトンサービスクラス。
class EventService {
    static var instance : EventService = {
        let instance = EventService()
        return instance
    }()
    
    var images = ["event1", "event6", "event4","event10","event5"]
    
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
        
        let a = Event(Int8(n))
        a.title = "title" + String(n)
        a.priceInfo  = "\(10 * n)"

        a.startDateTime = "2016-09-09"
        a.endDateTime = "2016-10-10"
        let gallery = Gallery(1,1)
        let content = Content(1)
//        content.data = UIImagePNGRepresentation(UIImage(named: images[n]))
        gallery.content = content
        a.gallery.append(gallery)
        
        a.likes = 10 + n
        
        return a;
    }

}
