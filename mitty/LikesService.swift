//
//  LikesService.swift
//  mitty
//
//  Created by gridscale on 2017/07/30.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

import SwiftyJSON

// シングルトンサービスクラス。
class LikesService: Service {

    static var instance: LikesService = {
        let instance = LikesService()
        return instance
    }()

    private override init() {

    }

    /// サーバーにいいねを送信。
    ///
    /// - Parameters:
    ///   - type: いいね対象タイプ。(EVENT/REQUEST/PROPOSAL)
    ///   - id: いいね対象ID。
    func sendLike(_ type: String, id: Int64) {

        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]

        let parameters: [String: Any] = [
            "type": type,
            "id": id
        ]
        
        let api = APIClient(path: "/send/like", method: .post, parameters: parameters, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            if (json == nil || json["ok"] == nil) {
                return
            }
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })
    }

    /// サーバーにいいねを削除。
    ///
    ///
    /// - Parameters:
    ///   - type: いいねを削除対象の種類。(EVENT/REQUEST/PROPOSAL)
    ///   - id: <#id description#>
    func removeLike(_ type: String, id: Int64) {

        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]

        let parameters: [String: Any] = [
            "type": type,
            "id": id
        ]
        
        let api = APIClient(path: "/remove/like", method: .post, parameters: parameters, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            if (json == nil || json["ok"] == nil) {
                return
            }
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })
    }
}
