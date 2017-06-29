//
//  UserService.swift
//  mitty
//
//  Created by gridscale on 2017/06/29.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//


import Foundation
import UIKit
import Alamofire
import SwiftyJSON

// シングルトンサービスクラス。
class UserService {
    let apiUserInfo = "http://dev.mitty.co/api/user/info"
    
    static var instance : UserService = {
        let instance = UserService()
        return instance
    }()
    
    private init() {
        
    }
    
    // サーバーからイベントを検索。
    func getUserInfo(id : String, callback: @escaping (_ user: UserInfo?, _ ok: Bool) -> Void ) {
        let parmeters = [
            "id" : id
        ]
        
        LoadingProxy.on()

        
        // ダミーコード、本当はサーバーから検索する。
        let request = Alamofire.request(apiUserInfo, method: .get, parameters: parmeters)
        request.validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                LoadingProxy.off()
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    print(json)
                    if (json == nil || json["userInfo"] == nil) {
                        callback(nil, false)
                        return
                    }
                    
                    let user = self.bindUserInfo(json["userInfo"])
                    callback(user, true)
                    return
                }
                
                callback(nil, false)

            case .failure(let error):
                LoadingProxy.off()
                print(error)
            }
        }
    }

    
    func bindUserInfo(_ jsUser: JSON) -> UserInfo {

        let user = UserInfo()
        
        user.id = jsUser["id"].intValue
        user.name = jsUser["name"].stringValue
        user.userName = jsUser["user_name"].stringValue
        user.mailAddress = jsUser["mail_address"].stringValue
        user.icon = jsUser["icon"].stringValue
        user.status = jsUser["status"].stringValue
        
        return user
    }
}
