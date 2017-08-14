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
        let eventMeetingUrl = MITTY_SERVICE_BASE_URL + "/latest/conversation"

        LoadingProxy.on()

        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]

        let parameters = [
            "meetingId": NSNumber(value: meetingId)
        ]

        Alamofire.request(eventMeetingUrl, method: .get, parameters: parameters, headers: httpHeaders).validate(statusCode: 200..<300).responseJSON { [weak self] response in
            switch response.result {
            case .success:
                LoadingProxy.off()
                var conversation = [Talk]()
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    let talks = json["conversations"]
                    print(json)
                    print(talks)

                    for (_, talk) in talks {
                        conversation.append((self?.bindConversation(talk))!)
                    }
                }

                callback (conversation)
                //  self?.navigationController?.popToRootViewController(animated: true)
            case .failure(let error):
                print(response.debugDescription)
                print(response.data ?? "No Data")
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    print(json)
                    onError("error occored")
                } catch {
                    print("Serialize Error")
                }

                print(response.description)

                LoadingProxy.off()
                print(error)
            }
        }

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
        let eventMeetingUrl = MITTY_SERVICE_BASE_URL + "/event/meeting"


        LoadingProxy.on()

        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]

        Alamofire.request(eventMeetingUrl, method: .get, headers: httpHeaders).validate(statusCode: 200..<300).responseJSON { [weak self] response in
            switch response.result {
            case .success:
                LoadingProxy.off()
                var meetingList = [MeetingInfo]()
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    let meetings = json["eventMeetingList"]

                    for (_, jsonMeeting) in meetings {
                        meetingList.append((self?.bindEventMeeting(jsonMeeting))!)
                    }
                }

                callback (meetingList)
                //  self?.navigationController?.popToRootViewController(animated: true)
            case .failure(let error):
                print(response.debugDescription)
                print(response.data ?? "No Data")
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    print(json)
                    onError("error occored")
                } catch {
                    print("Serialize Error")
                }

                print(response.description)

                LoadingProxy.off()
                print(error)
            }
        }

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

