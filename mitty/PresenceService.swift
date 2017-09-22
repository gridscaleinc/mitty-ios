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
    let apiCheckin = MITTY_SERVICE_BASE_URL + "/checkin"
    
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
        Alamofire.request(apiCheckin, method: .post, parameters: parameters, headers: httpHeaders).validate(statusCode: 200..<300).responseJSON { response in
            LoadingProxy.off()
            switch response.result {
            case .success:
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    print(json)
                    if (json == nil || json["ok"] == nil) {
                        return
                    }

                    return
                }
                
                break
                
            case .failure(let error):
                print(error)
                onError(error.localizedDescription)
                print(super.jsonResponse(response))
                LoadingProxy.off()
            }
        }
    }
    
    // heartbeat
}

