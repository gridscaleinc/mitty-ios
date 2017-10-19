//
//  RequestService.swift
//  mitty
//
//  Created by gridscale on 2017/06/12.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/// リケエストサービス。
class RequestService: Service {
    let urlSearch = MITTY_SERVICE_BASE_URL + "/search/request"
    let urlMyrequest = MITTY_SERVICE_BASE_URL + "/myrequest"
    let registerUrl = MITTY_SERVICE_BASE_URL + "/new/request"
    let requestDetails = MITTY_SERVICE_BASE_URL + "/request/details"
    

    static var instance: RequestService = {
        let instance = RequestService()
        return instance
    }()

    private override init() {

    }

    /// リクエスト登録。
    ///
    /// - Parameters:
    ///   - req: リクエスト情報。
    ///   - onSuccess: 正常時に呼び出されるコールバック。
    ///   - onError: エラー時に呼び出されるコールバック。
    func register(_ req: NewRequestReq, onSuccess: @escaping (() -> Void), onError: @escaping ((_ error: String) -> Void)) {

        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]

        LoadingProxy.on()
        
        let api = APIClient(path: "/new/request", method: .post, parameters: req.parameters, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            let requestId = json["id"].stringValue
            onSuccess()
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })

    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - key: <#key description#>
    ///   - callback: <#callback description#>
    func getMyRequests (key: String, callback: @escaping (_ request: [RequestInfo]) -> Void) {
        let parameters: [String: Any] = [
            "q": key,
        ]

        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]



        LoadingProxy.on()

        // ダミーコード、本当はサーバーから検索する。
        var requests = [RequestInfo]()
        
        let api = APIClient(path: "/myrequest", method: .get, parameters: parameters, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            if (json == nil || json["requests"] == nil) {
                callback([])
                return
            }
            for (_, jsonReq) in json["requests"] {
                requests.append(self.bindRequestInfo(jsonReq))
            }
            callback(requests)
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })

    }

    /// 検索。
    /// キーワードによる検索。（曖昧検索）
    /// - Parameters:
    ///   - keys: 検索キー
    ///   - callback: コールバック。
    func search (keys: String, callback: @escaping (_ request: [RequestInfo]) -> Void) {
        let parameters: [String: Any] = [
            "q": keys,
            "offset": 0,
            "limit": 30,
        ]

        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]

        LoadingProxy.on()

        // ダミーコード、本当はサーバーから検索する。
        var requests = [RequestInfo]()
        
        let api = APIClient(path: "/search/request", method: .get, parameters: parameters, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            if (json == nil || json["requests"] == nil) {
                callback([])
                return
            }
            for (_, jsonReq) in json["requests"] {
                requests.append(self.bindRequestInfo(jsonReq))
            }
            callback(requests)
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })

    }

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - id: <#id description#>
    ///   - onComplete: <#onComplete description#>
    func getRequestDetail(_ id: Int64, onComplete: @escaping ( _ r: RequestInfo ) -> Void ) {
        let parameters: [String: Any] = [
            "id": id,
            ]
        
        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]
        
        LoadingProxy.on()
        
        let api = APIClient(path: "/request/details", method: .get, parameters: parameters, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            if (json == nil || json["request"] == nil) {
                return
            }
            let requestJson = json["request"]
            let req = self.bindRequestInfo(requestJson)
            onComplete(req)
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })
    }

    
    /// リクエストバインド。
    ///
    /// - Parameter json: JSON.
    /// - Returns: リクエスト情報。
    func bindRequestInfo(_ json: JSON) -> RequestInfo {
        let info = RequestInfo()
        info.id = json["id"].int64Value
        info.title = json["title"].stringValue
        info.tag = json["tag"].stringValue
        info.desc = json["description"].stringValue
        info.forActivityId = json["for_activity_id"].int64Value
        info.preferredDatetime1 = json["preferred_datetime1"].stringValue.utc2Date()
        info.preferredDatetime2 = json["preferred_datetime2"].stringValue.utc2Date()
        info.preferredPrice1 = json["preferred_price1"].int64Value
        info.preferredPrice2 = json["preferred_price2"].int64Value
        info.startPlace = json["start_place"].stringValue
        info.terminatePlace = json["terminate_place"].stringValue
        info.oneway = json["oneway"].stringValue
        info.status = json["status"].stringValue
        info.expiryDate = json["expiry_date"].stringValue.utc2Date()
        info.numOfPerson = json["num_of_person"].intValue
        info.numOfChildren = json["num_of_children"].intValue
        info.acceptedProposalId = json["accepted_proposal_id"].int64Value
        info.acceptedDate = json["accepted_date"].stringValue.utc2Date()
        info.meetingId = json["meeting_id"].int64Value
        info.ownerId = json["owner_id"].intValue
        info.created = json["created"].stringValue.utc2Date()
        info.numberOfLikes = json["num_of_likes"].intValue
        info.numberOfProposals = json["num_of_proposal"].intValue
        info.ownerName = json["owner_name"].stringValue
        info.ownerIconUrl = json["owner_icon_url"].stringValue
        

        return info
    }

}
