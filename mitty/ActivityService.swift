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
        
        LoadingProxy.on()
        
        let httpHeaders = [
            "X-Mitty-AccessToken" : ApplicationContext.userSession.accessToken
        ]
        
        // ダミーコード、本当はサーバーから検索する。
        var activities = [ActivityInfo]()
        let request = Alamofire.request(urlBase, method: .get, parameters: parmeters, headers: httpHeaders)
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
        
        act.mainEventId = jsAct["eventId"].stringValue
        act.title = jsAct["title"].stringValue
        act.startDateTime = jsAct["startDateTime"].stringValue
        act.logoUrl = jsAct["eventLogoUrl"].stringValue
        
        act.logoUrl = "timesquare"
        
        return act
    }
    
    func fetch(id: String, _ callback: @escaping( _ act: Activity) -> Void  ) {
        
        let urlString = "http://dev.mitty.co/api/activity/details"
        
        let parmeters = [
            "id" : id
        ]
        
        let httpHeaders = [
            "X-Mitty-AccessToken" : ApplicationContext.userSession.accessToken
        ]
        
        LoadingProxy.on()
        
        // ダミーコード、本当はサーバーから検索する。
        var activity : Activity = Activity()
        let request = Alamofire.request(urlString, method: .get, parameters: parmeters, headers: httpHeaders)
        request.validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                LoadingProxy.off()
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                     activity = self.bindActivityDetails(json)
                }
                
                callback(activity)
                
            case .failure(let error):
                LoadingProxy.off()
                print(error)
            }
        }

    }
    
    func getDestinationList(_ callback: @escaping(_ events: [Destination]) -> Void ) {
        
        let urlString = "http://dev.mitty.co/api/destination/list"
        

        let httpHeaders = [
            "X-Mitty-AccessToken" : ApplicationContext.userSession.accessToken
        ]
        
        LoadingProxy.on()
        
        // ダミーコード、本当はサーバーから検索する。
        var destinations = [Destination]()
        let request = Alamofire.request(urlString, method: .get, headers: httpHeaders)
        request.validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                LoadingProxy.off()
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    print(json)
                    if (json == nil || json["destinations"] == nil) {
                        callback([])
                        return
                    }
                    
                    for ( _, dest) in json["destinations"] {
                        destinations.append(self.bindDestination(dest))
                    }
                }
                
                callback(destinations)
                
            case .failure(let error):
                LoadingProxy.off()
                print(error)
            }
        }
        
    }
    
    func bindDestination(_ json: JSON) -> Destination {
        let d = Destination()
        d.islandId = json["islandId"].intValue
        d.islandName = json["islandName"].stringValue
        d.islandNickName = json["islandNickName"].stringValue
        d.latitude = json["latitude"].doubleValue
        d.longitude = json["longitude"].doubleValue
        d.islandLogo = json["islandLogo"].stringValue
        d.eventId = json["eventId"].intValue
        d.eventTitle = json["eventTitle"].stringValue
        
        if let time = json["eventTime"].stringValue.dateFromISO8601 {
            d.eventTime = time
        }
        print(d.longitude)
        
        return d
        
    }
    func bindActivityDetails(_ json: JSON) -> Activity {
        let a = Activity()
        let info = ActivityInfo()
        a.info = info
        print(json)
        let infoJson = json["activity"]
        info.id = infoJson["id"].stringValue
        info.title = infoJson["title"].stringValue
        info.mainEventId = infoJson["main_event_id"].stringValue
        info.memo = infoJson["memo"].stringValue
        
        for (_, detailJson) in json["details"] {
            let item = ActivityItem()
            item.eventId = detailJson["eventId"].stringValue
            item.title = detailJson["title"].stringValue
            item.memo = detailJson["memo"].stringValue
            item.notification = detailJson["notification"].boolValue
            item.notificationTime = detailJson["notificationTime"].stringValue
            item.eventTitle = detailJson["eventTitle"].stringValue
            item.startDateTime = detailJson["startDateTime"].stringValue
            item.endDateTime = detailJson["endDateTime"].stringValue
            item.allDayFlag = detailJson["allDayFlag"].boolValue
            item.eventLogoUrl = detailJson["eventLogoUrl"].stringValue
            item.islandName = detailJson["islandName"].stringValue
            item.islandNickname = detailJson["islandNickname"].stringValue
            item.islandLogoUrl = detailJson["islandLogoUrl"].stringValue
            a.items.append(item)
        }
        return a
    }
    
}
