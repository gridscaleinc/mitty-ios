//
//  ActivityService.swift
//  mitty
//
//  Created by gridscale on 2017/05/12.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

// シングルトンサービスクラス。
class ActivityService {
    let urlBase = "http://dev.mitty.co/api/activity/list"
    
    static var instance : ActivityService = {
        let instance = ActivityService()
        return instance
    }()
    
    private init() {
        
    }
    
    // サーバーからイベントを検索。
    func search(keys : String, callback: @escaping (_ events: [ActivityInfo]) -> Void ) {
        let parmeters = [
            "q" : keys
        ]
        
        // ダミーコード、本当はサーバーから検索する。
        var activities = [ActivityInfo]()
        let request = Alamofire.request(urlBase, method: .get, parameters: parmeters)
        request.validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                LoadingProxy.off()
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    print(json)
                    if (json == nil || json["activities"] == nil) {
                        callback([])
                        return
                    }
                    
                    for ( _, activityInfo) in json["activities"] {
                        activities.append(self.bindActivity(activityInfo))
                    }
                }
                
                callback(activities)
                
            case .failure(let error):
                LoadingProxy.off()
                print(error)
            }
        }
    }
    
    func bindActivity(_ jsAct: JSON) -> ActivityInfo {
        let id = jsAct["id"].stringValue
        let act = ActivityInfo()
        act.id = id
        
        act.mainEventId = jsAct["eventId"].int64
        act.title = jsAct["title"].stringValue
        act.startDateTime = jsAct["startDateTime"].stringValue
        act.logoUrl = jsAct["eventLogoUrl"].stringValue
        
        act.logoUrl = "timesquare"
        
        return act
    }
    
}
