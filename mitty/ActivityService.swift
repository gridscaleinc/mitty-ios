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
    let urlBase = MITTY_SERVICE_BASE_URL + "/activity/list"
    
    static var instance : ActivityService = {
        let instance = ActivityService()
        return instance
    }()
    
    private init() {
        
    }
    
    func register(_ title: String, _ memo: String, _ mainEventId: String,
                  onCompletion : @escaping (_ info: ActivityInfo ) -> Void,
                  onError : @escaping (_ error: String ) -> Void ) {
        
        let urlString = MITTY_SERVICE_BASE_URL + "/new/activity"
        
        let parameters: Parameters = [
            "title": title,
            "memo": memo,
            "mainEventId": mainEventId
        ]
        
        let httpHeaders = [
            "X-Mitty-AccessToken" : ApplicationContext.userSession.accessToken
        ]
        
        
        LoadingProxy.on()
        
        print(parameters)
        Alamofire.request(urlString, method: .post, parameters: parameters, headers: httpHeaders).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                LoadingProxy.off()
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)

                        let activityId = json["activityId"].stringValue
                        
                        let activityInfo = ActivityInfo()
                        activityInfo.title = parameters["title"] as! String
                        activityInfo.memo = parameters["memo"] as? String
                        activityInfo.id = activityId
                        activityInfo.mainEventId = mainEventId
                        onCompletion (activityInfo)
                        
                }
                
            case .failure(let error):
                print(response.debugDescription)
                print(response.data ?? "No Data")
                print(error)
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    print(json)
                    
                } catch {
                    onError("応答電文エラー。")
                }
                
                print(response.description)
                
                LoadingProxy.off()
                
            }
        }
    }
    
    func save(_ info: ActivityInfo,
                  onCompletion : @escaping (_ info: ActivityInfo ) -> Void,
                  onError : @escaping (_ error: String ) -> Void ) {
        
        let urlString = MITTY_SERVICE_BASE_URL + "/update/activity"
        
        let parameters: Parameters = [
            "activityId" : info.id,
            "title": info.title,
            "memo": info.memo ?? "",
        ]
        
        let httpHeaders = [
            "X-Mitty-AccessToken" : ApplicationContext.userSession.accessToken
        ]
        
        
        LoadingProxy.on()
        
        print(parameters)
        Alamofire.request(urlString, method: .post, parameters: parameters, headers: httpHeaders).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                LoadingProxy.off()
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    
                    let activityId = json["activityId"].stringValue
                    if (activityId != "") {
                        onCompletion (info)
                    }
                    
                }
                
            case .failure(let error):
                print(response.debugDescription)
                print(response.data ?? "No Data")
                print(error)
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    print(json)
                    
                } catch {
                    onError("応答電文エラー。")
                }
                
                print(response.description)
                
                LoadingProxy.off()
                
            }
        }
    }

    //
    func registerItem(_ actId: String, _ title: String, _ memo: String, _ eventId: String, notify: Bool, notifyTime : Date?,
                      asMainEvent: Bool, onCompletion : @escaping (_ actItem: ActivityItem ) -> Void,
                  onError : @escaping (_ error: String ) -> Void ) {
        
        let urlString = MITTY_SERVICE_BASE_URL + "/new/activity/item"
        
        let request = JSONRequest()
        
        request.setStr(named: "activityId", value: actId)
        request.setStr(named: "title", value: title)
        request.setStr(named: "memo", value: memo)
        request.setStr(named: "eventId", value: eventId)
        request.setStr(named: "notification", value: (notify ? "true" : "false"))
        if (notify) {
            request.setDate(named: "notificationDateTime", date: notifyTime!)
        }
        request.setStr(named: "asMainEvent", value: (asMainEvent ? "true" : "false"))
        
        let parameters = request.parameters
        
        let httpHeaders = [
            "X-Mitty-AccessToken" : ApplicationContext.userSession.accessToken
        ]
        
        LoadingProxy.on()
        
        print(parameters)
        Alamofire.request(urlString, method: .post, parameters: parameters, headers: httpHeaders).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                
                LoadingProxy.off()
                
                let item = ActivityItem()
                item.allDayFlag = false
                item.eventId = eventId
                item.title = title
                item.memo = memo
                
                onCompletion(item)
                
            case .failure(let error):
                print(response.debugDescription)
                print(response.data ?? "No Data")
                print(error)
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    print(json)
                    
                } catch {
                    onError("応答電文エラー。")
                }
                
                print(response.description)
                
                LoadingProxy.off()
                
            }
        }
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
        
        let urlString = MITTY_SERVICE_BASE_URL + "/activity/details"
        
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
        
        let urlString = MITTY_SERVICE_BASE_URL + "/destination/list"
        

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
        
        d.eventTime = json["eventTime"].stringValue.utc2Date()
        
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
