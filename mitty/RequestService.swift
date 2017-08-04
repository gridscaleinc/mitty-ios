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

class RequestService {
    let urlSearch = MITTY_SERVICE_BASE_URL + "/search/request"
    let urlMyrequest = MITTY_SERVICE_BASE_URL + "/myrequest"
    
    static var instance : RequestService = {
        let instance = RequestService()
        return instance
    }()
    
    private init() {
        
    }
    
    func getMyRequests (key : String, callback: @escaping (_ request: [RequestInfo]) -> Void ) {
        let parmeters : [String : Any] = [
            "q" : key,
            ]
        
        let httpHeaders = [
            "X-Mitty-AccessToken" : ApplicationContext.userSession.accessToken
        ]
        
        
        
        LoadingProxy.on()
        
        // ダミーコード、本当はサーバーから検索する。
        var requests = [RequestInfo]()
        let request = Alamofire.request(urlMyrequest, method: .get, parameters: parmeters, headers: httpHeaders)
        request.validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                LoadingProxy.off()
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    print(json)
                    
                    if (json == nil || json["requests"] == nil) {
                        callback([])
                        return
                    }
                    
                    for ( _, jsonReq) in json["requests"] {
                        requests.append(self.bindRequestInfo(jsonReq))
                    }
                    callback(requests)
                }
                
            case .failure(let error):
                LoadingProxy.off()
                print(error)
            }
        }
        
    }
    
    func search (keys : String, callback: @escaping (_ request: [RequestInfo]) -> Void ) {
        let parmeters : [String : Any] = [
            "q" : keys,
            "offset" : 0,
            "limit" : 30,
        ]
        
        let httpHeaders = [
            "X-Mitty-AccessToken" : ApplicationContext.userSession.accessToken
        ]
        
        LoadingProxy.on()
        
        // ダミーコード、本当はサーバーから検索する。
        var requests = [RequestInfo]()
        let request = Alamofire.request(urlSearch, method: .get, parameters: parmeters, headers: httpHeaders)
        request.validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                LoadingProxy.off()
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    print(json)

                    if (json == nil || json["requests"] == nil) {
                        callback([])
                        return
                    }
                    
                    for ( _, jsonReq) in json["requests"] {
                        requests.append(self.bindRequestInfo(jsonReq))
                    }
                    callback(requests)
                }
                
            case .failure(let error):
                LoadingProxy.off()
                print(error)
            }
        }

    }

    func bindRequestInfo(_ json: JSON) -> RequestInfo {
        let info = RequestInfo()
        info.id	= json["id"].int64Value
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
        info.ownerId = json["owner_id"].int64Value
        info.created = json["created"].stringValue.utc2Date()
        info.updated = json["updated"].stringValue.utc2Date()
        
        return info
    }

}
