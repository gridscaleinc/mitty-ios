//
//  PresenceService.swift
//  mitty
//
//  Created by gridscale on 2017/09/20.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

import SwiftyJSON

// シングルトンサービスクラス。
class PresenceService: Service {
    
    static var instance: PresenceService = {
        let instance = PresenceService()
        return instance
    }()
    
    private override init() {
        
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - profile: <#profile description#>
    ///   - onComplete: <#onComplete description#>
    ///   - onError: <#onError description#>
    func checkIn(_ destination: Destination, _ namecardId: Int64? = 0, picId:Int64? = 0, info:String? = "", onError: @escaping (_ err: String) -> Void) {
        
        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]
        
        //
        let parameters: [String: Any] = [
            "event_id": destination.eventId,
            "island_id": destination.islandId,
            "name_card_id": namecardId ?? 0,
            "picture_id": picId ?? 0,
            "seat_or_room_info": info ?? ""
        ]
        
        LoadingProxy.on()
        
        let api = APIClient(path: "/checkin", method: .post, parameters: parameters, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            if (json == nil || json["ok"] == nil) {
                return
            }
            return
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })
    }
    
    // heartbeat
}

