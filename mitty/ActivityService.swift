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

/// 活動に関するサービス。
class ActivityService: Service {
    
    /// シングルトンインスタンス。
    static var instance: ActivityService = {
        let instance = ActivityService()
        return instance
    }()

    /// シングルトン実装のため、initをプライベート化。
    private override init() {

    }

    
    /// 活動計画登録。
    ///
    /// - Parameters:
    ///   - title: 活動タイトル。
    ///   - memo: 活動に関するメモ。
    ///   - mainEventId: メインイベントのID.
    ///   - onCompletion: 登録成功時の呼び出し処理。
    ///   - onError: エラー時に呼び出し処理。
    func register(_ title: String, _ memo: String, _ mainEventId: String,
                  onCompletion: @escaping (_ info: ActivityInfo) -> Void,
                  onError: @escaping (_ error: String) -> Void) {

        let parameters: Parameters = [
            "title": title,
            "memo": memo,
            "mainEventId": mainEventId
        ]

        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]


        LoadingProxy.on()
        
        let api = APIClient(path: "/new/activity", method: .post, parameters: parameters, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            
            let activityId = json["activityId"].stringValue
            
            let activityInfo = ActivityInfo()
            activityInfo.title = parameters["title"] as! String
            activityInfo.memo = parameters["memo"] as? String
            activityInfo.id = activityId
            activityInfo.mainEventId = mainEventId
            onCompletion (activityInfo)
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })

    }

    
    /// 活動内容保存。
    ///
    /// - Parameters:
    ///   - info: 活動情報オブジェクト。
    ///   - onCompletion: 保存処理成功時の非同期に呼び出し処理。
    ///   - onError: エラー時非同期に呼び出す処理。
    func save(_ info: ActivityInfo,
              onCompletion: @escaping (_ info: ActivityInfo) -> Void,
              onError: @escaping (_ error: String) -> Void) {

        let parameters: Parameters = [
            "activityId": info.id,
            "title": info.title,
            "memo": info.memo ?? "",
        ]

        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]


        LoadingProxy.on()
        
        let api = APIClient(path: "/update/activity", method: .post, parameters: parameters, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            
            let activityId = json["activityId"].stringValue
            if (activityId != "") {
                onCompletion (info)
            }
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })

    }

    
    /// 活動アイテム保存処理。
    ///
    /// - Parameters:
    ///   - item: アイテムオブジェクト。
    ///   - onCompletion: 保存成功時に非同期に呼び出される処理
    ///   - onError: エラー時に非同期に呼び出される処理。
    func saveItem(_ item: ActivityItem,
                  onCompletion: @escaping (_ info: ActivityItem) -> Void,
                  onError: @escaping (_ error: String) -> Void) {

        let parameters: Parameters = [
            "id": item.id,
            "activityId": item.activityId,
            "eventId": item.eventId,
            "title": item.title,
            "memo": item.memo,
            "notification": item.notification ? "true" : "false",
            "notificationDateTime": item.notificationTime.iso8601LongUTC
        ]

        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]

        LoadingProxy.on()
        
        let api = APIClient(path: "/update/activity/item", method: .post, parameters: parameters, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            
            let activityId = json["id"].stringValue
            if (activityId != "") {
                onCompletion (item)
            }
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })
        
    }


    //
    /// 活動アイテム登録。
    ///
    /// - Parameters:
    ///   - actId: 活動ID.
    ///   - title: 活動アイテムのタイトル。
    ///   - memo: 活動アイテムに関するメモ。
    ///   - eventId: 活動に関するイベントID.
    ///   - notify: アラームで知らせる要否。
    ///   - notifyTime: アラーム要の場合、その時刻。
    ///   - asMainEvent: メインイベントであるかどうかを示すフラグ。
    ///   - onCompletion: 正常に登録された場合の非同期に呼び出される処理。
    ///   - onError: エラー時に非同期に呼び出される処理。
    func registerItem(_ actId: String, _ title: String, _ memo: String, _ eventId: String, notify: Bool, notifyTime: Date?,
                      asMainEvent: Bool, onCompletion: @escaping (_ actItem: ActivityItem) -> Void,
                      onError: @escaping (_ error: String) -> Void) {

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
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]

        LoadingProxy.on()
        
        let api = APIClient(path: "/new/activity/item", method: .post, parameters: parameters, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            
            let item = ActivityItem()
            item.allDayFlag = false
            item.eventId = eventId
            item.title = title
            item.memo = memo
            
            onCompletion(item)
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })
        

    }

    /// サーバーから活動を検索。
    ///
    /// - Parameters:
    ///   - keys: 検索結果をフィルタするためのキー項目。キー項目が含まれる活動のみ検索される。
    ///   - callback: 検索結果が返された場合の呼び出し処理。
    func search(keys: String, callback: @escaping (_ events: [ActivityInfo]) -> Void) {
        let parameters = [
            "q": keys
        ]

        LoadingProxy.on()

        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]

        // ダミーコード、本当はサーバーから検索する。
        var activities = [ActivityInfo]()

        let api = APIClient(path: "/activity/list", method: .get, parameters: parameters, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            print(json)
            if (json == nil || json["activities"] == nil) {
                callback([])
                return
            }
            for (_, activityInfo) in json["activities"] {
                activities.append(self.bindActivity(activityInfo))
            }
            callback(activities)
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })
    }


    /// 検索結果から活動オブジェクトをバインド。
    ///
    /// - Parameter jsAct: 活動情報のJSONオブジェクト。
    /// - Returns: バインドされた活動情報オブジェクト。
    func bindActivity(_ jsAct: JSON) -> ActivityInfo {
        let id = jsAct["id"].stringValue
        let act = ActivityInfo()
        act.id = id

        act.mainEventId = jsAct["eventId"].stringValue
        act.title = jsAct["title"].stringValue
        act.startDateTime = jsAct["startDateTime"].stringValue
        act.logoUrl = jsAct["eventLogoUrl"].stringValue

//        act.logoUrl = "timesquare"

        return act
    }

    
    /// Description
    ///
    /// - Parameters:
    ///   - id: event Id
    ///   - callback: removal result, Ok/Ng
    func removeEventItem(id: String, _ callback: @escaping(_ resut: Bool) -> Void) {
        
        let parameters = [
            "id": id
        ]
        
        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]
        
        LoadingProxy.on()
        
        let api = APIClient(path: "/remove/eventItem", method: .post, parameters: parameters, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            let result = json["result"].boolValue
            callback(result)
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })
        
    }
    
    /// Description
    ///
    /// - Parameters:
    ///   - id: <#id description#>
    ///   - callback: <#callback description#>
    func fetch(id: String, _ callback: @escaping(_ act: Activity) -> Void) {

        let parameters = [
            "id": id
        ]

        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]

        LoadingProxy.on()

        // ダミーコード、本当はサーバーから検索する。
        var activity: Activity = Activity()
        
        let api = APIClient(path: "/activity/details", method: .get, parameters: parameters, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            activity = self.bindActivityDetails(json)
            callback(activity)
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })

    }

    
    /// <#Description#>
    ///
    /// - Parameter callback: <#callback description#>
    func getDestinationList(_ callback: @escaping(_ events: [Destination]) -> Void) {

        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]

        LoadingProxy.on()

        // ダミーコード、本当はサーバーから検索する。
        var destinations = [Destination]()
        
        let api = APIClient(path: "/destination/list", method: .get, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            if (json == nil || json["destinations"] == nil) {
                callback([])
                return
            }
            for (_, dest) in json["destinations"] {
                destinations.append(self.bindDestination(dest))
            }
            callback(destinations)
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })


    }

    /// <#Description#>
    ///
    /// - Parameter json: <#json description#>
    /// - Returns: <#return value description#>
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
        d.eventLogo = json["eventLogo"].stringValue
        d.eventTime = json["eventTime"].stringValue.utc2Date()

        print(d.longitude)

        return d

    }

    /// 活動の詳細情報をバインド。
    /// 活動及びその関連アイテムを検索し、その結果をバインド。
    /// - Parameter json: JSONオブジェクト。
    /// - Returns: 活動及び関連アイテム情報。
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
            item.id = detailJson["id"].int64Value
            item.activityId = detailJson["activityId"].int64Value
            item.eventId = detailJson["eventId"].stringValue
            item.title = detailJson["title"].stringValue
            item.memo = detailJson["memo"].stringValue
            item.notification = detailJson["notification"].boolValue
            item.notificationTime = detailJson["notificationTime"].stringValue.utc2Date()
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
    
    /// <#Description#>
    ///
    /// - Parameter id: <#id description#>
    func removeActivity(id : Int64, onComplete : @escaping () ->Void ) {
        
        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]
        
        LoadingProxy.on()
        
        let api = APIClient(path: "/remove/activity" + "?id=" + String(id), method: .post, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            if (json == nil || json["ok"] == nil) {
                return
            }
            onComplete()
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })
    }
    
    /// <#Description#>
    ///
    /// - Parameter id: <#id description#>
    func removeItem(id : Int64, of activityId: Int64, onComplete : @escaping () ->Void ) {
        
        let parameters = [
            "itemId" : id,
            "activityId": activityId
        ]
        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]
        
        LoadingProxy.on()
        
        let api = APIClient(path: "/remove/activityItem", method: .post, parameters: parameters, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            if (json == nil || json["ok"] == nil) {
                return
            }
            onComplete()
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })

    }

}
