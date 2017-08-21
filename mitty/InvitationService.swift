//
//  InvitationService.swift
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
class InvitationService: Service {
    let apiSendInvitation = MITTY_SERVICE_BASE_URL + "/send/invitation"

    static var instance: InvitationService = {
        let instance = InvitationService()
        return instance
    }()

    private override init() {

    }
    
    /// 招待を送信。
    ///
    /// - Parameters:
    ///   - type: 招待の種類。(EVENT: イベントへの招待)
    ///   - id: 招待対象のID.
    ///   - message: 招待にあったてのメッセージ。
    ///   - userId: 招待を受けるユーザーのID(複数）.
    func sendInvitation(_ type: String, id: Int64, message: String, userId: [Int]) {

        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]

        let parmeters: [String: Any] = [
            "forType": type,
            "idOfType": id,
            "message": message,
        ]

        Alamofire.request(apiSendInvitation, method: .post, parameters: parmeters, headers: httpHeaders).validate(statusCode: 200..<300).responseJSON { response in
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
                print(super.jsonResponse(response))
                print(response.description)
                LoadingProxy.off()
            }
        }
    }
}
