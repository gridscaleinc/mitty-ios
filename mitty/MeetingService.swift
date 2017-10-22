//
//  MeetingService.swift
//  mitty
//
//  Created by gridscale on 2017/06/04.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

// シングルトンサービスクラス。
class MeetingService: Service {
    static var instance: MeetingService = {
        let instance = MeetingService()
        return instance
    }()

    private override init() {

    }

    
    /// 直近の会話を取得。
    ///
    /// - Parameter meetingId: 会議室番号。
    ///             callback: 会話一覧を渡すためのコールバック。
    ///             onError: エラー時のコールバック。
    /// - Returns: なし。
    func getLatestConversation(_ meetingId: Int64, callback: @escaping (_ talkList: [Talk]) -> Void, onError: @escaping (_ error: Any) -> Void = { _ in }) {
        LoadingProxy.on()

        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]

        let parameters = [
            "meetingId": NSNumber(value: meetingId)
        ]

        let api = APIClient(path: "/latest/conversation", method: .get, parameters: parameters, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            var conversation = [Talk]()
            let jsonObject = data
            let json = JSON(jsonObject)
            let talks = json["conversations"]
            for (_, talk) in talks {
                conversation.append((self.bindConversation(talk)))
            }
            callback (conversation)
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })

    }

    /// 会話オブジェクトバインド。
    ///
    /// - Parameter js: JSON
    /// - Returns: 会話オブジェクト。
    func bindConversation(_ js: JSON) -> Talk {
        let tk1 = Talk()

        tk1.meetingId = js["meetingId"].int64!
        tk1.speakerId = js["speakerId"].int64!
        tk1.speakTime = js["speakTime"].stringValue.utc2Date()
        tk1.speaking = js["speaking"].rawString()!

        return tk1

    }

    /// 参加しているイベントの会議一覧取得。
    ///
    /// - Parameter callback: 会議一覧を渡すためのコールバック。
    ///             onError: エラー時のコールバック。
    /// - Returns: なし。
    func getEventMeeting(callback: @escaping (_ meetingList: [MeetingInfo]) -> Void, onError: @escaping (_ error: Any) -> Void = { _ in }) {

        LoadingProxy.on()

        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]
        
        let api = APIClient(path: "/event/meeting", method: .get, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            let meetings = json["eventMeetingList"]
            var meetingList = [MeetingInfo]()
            for (_, jsonMeeting) in meetings {
                meetingList.append((self.bindEventMeeting(jsonMeeting)))
            }
            callback(meetingList)
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })

    }

    func getRequestMeeting(callback: @escaping (_ meetingList: [MeetingInfo]) -> Void, onError: @escaping (_ error: Any) -> Void = { _ in }) {
        
        LoadingProxy.on()
        
        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]
        
        let api = APIClient(path: "/myrequest/meeting", method: .get, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            let meetings = json["requestMeetingList"]
            var meetingList = [MeetingInfo]()
            for (_, jsonMeeting) in meetings {
                meetingList.append((self.bindEventMeeting(jsonMeeting)))
            }
            callback(meetingList)
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })
        
    }
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    func getContactMeeting(callback: @escaping (_ meetingList: [MeetingInfo]) -> Void, onError: @escaping (_ error: Any) -> Void = { _ in }) {
        
        LoadingProxy.on()
        
        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]
        
        let api = APIClient(path: "/contact/meeting", method: .get, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            let meetings = json["contactMeetingList"]
            var meetingList = [MeetingInfo]()
            for (_, jsonMeeting) in meetings {
                let meeting = self.bindEventMeeting(jsonMeeting)
                
                meetingList.append(meeting)
            }
            callback(meetingList)
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })
        
    }
    
    /// 会議情報バインド。
    ///
    /// - Parameter json: JSONオブジェクト。
    /// - Returns: 会議情報。
    func bindEventMeeting(_ json: JSON) -> MeetingInfo {
        let meeting = MeetingInfo()

        meeting.id = json["id"].int64!
        meeting.name = json["name"].stringValue
        meeting.type = json["type"].stringValue
        meeting.title = json["title"].stringValue
        meeting.logoUrl = json["logoUrl"].stringValue
        meeting.created = json["created"].stringValue.utc2Date()
        meeting.updated = json["updated"].stringValue.utc2Date()
        print(json)
        return meeting
    }
}

