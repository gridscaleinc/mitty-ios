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
class UserService: Service {
    let apiUserInfo = MITTY_SERVICE_BASE_URL + "/user/info"
    let apiSetUserIcon = MITTY_SERVICE_BASE_URL + "/update/user/icon"

    static var instance: UserService = {
        let instance = UserService()
        return instance
    }()

    private override init() {

    }

    
    /// ユーザーアイコンを設定。
    ///
    /// - Parameter contentId: 設定するアイコンのコンテンツID.
    func setUserIcon(_ contentId: Int64) {
        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]
        
        let api = APIClient(path: "/update/user/icon" + "?contentId=\(contentId)", method: .post, headers: httpHeaders)
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


    
    /// ユーザー情報取得。
    ///
    /// - Parameters:
    ///   - id: ユーザーID
    ///   - callback: コールバック。
    func getUserInfo(id: String, callback: @escaping (_ user: UserInfo?, _ ok: Bool) -> Void) {
        let parameters = [
            "id": id
        ]

        LoadingProxy.on()
        
        let api = APIClient(path: "/user/info", method: .get, parameters: parameters)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            if (json == nil || json["userInfo"] == nil) {
                callback(nil, false)
                return
            }
            let user = self.bindUserInfo(json["userInfo"])
            callback(user, true)
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })
    }


    /// ユーザー情報バインド。
    ///
    /// - Parameter jsUser: JSON
    /// - Returns: ユーザー情報。
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
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - userName: <#userName description#>
    ///   - pwd: <#pwd description#>
    ///   - onComplete: <#onComplete description#>
    ///   - onError: <#onError description#>
    func signin(userName: String, pwd: String, onComplete: @escaping (_ uid: Int, _ token: String) -> Void,
                onError: @escaping (_ e: String) -> Void) {
        
        let parameters: Parameters = [
            "user_name": userName,
            "password": pwd
        ]
        
        LoadingProxy.on()
        
        let api = APIClient(path: "/signin", method: .post, parameters: parameters)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            let userid = json["user_id"].intValue
            let accessToken = json["access_token"].stringValue
            onComplete(userid, accessToken)
        }, fail: {(error: Error?) in
            print(error as Any)
            onError("ユーザーIDまたはパスワードが正しくない。")
            LoadingProxy.off()
        })
    }
}
