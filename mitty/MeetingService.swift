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
class  MeetingService {
    static var instance : MeetingService = {
        let instance = MeetingService()
        return instance
    }()
    
    private init() {
        
    }
    
    func getEventMeeting(callback: @escaping (_ meetingList: [MeetingInfo]) -> Void, onError: @escaping (_ error: Any) -> Void = {_ in } ) {
        let eventMeetingUrl = "http://dev.mitty.co/api/event/meeting"
        
        
        LoadingProxy.on()
        
        let httpHeaders = [
            "X-Mitty-AccessToken" : ApplicationContext.userSession.accessToken
        ]
        
        Alamofire.request(eventMeetingUrl, method: .get, headers : httpHeaders).validate(statusCode: 200..<300).responseJSON { [weak self] response in
            switch response.result {
            case .success:
                LoadingProxy.off()
                var meetingList = [MeetingInfo]()
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    let meetings = json["eventMeetingList"]
                    
                    for ( _, jsonMeeting) in meetings {
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

    func bindEventMeeting(_ json : JSON) -> MeetingInfo {
        let meeting = MeetingInfo()
        
        meeting.id = json["id"].int64!
        meeting.name = json["name"].stringValue
        meeting.type = json["type"].stringValue
        meeting.title = json["title"].stringValue
        meeting.logoUrl = json["logoUrl"].stringValue
        meeting.created = json["created"].stringValue.dateFromISO8601Long!
        meeting.updated = json["updated"].stringValue.dateFromISO8601Long!
        print(json)
        return meeting
    }
}

