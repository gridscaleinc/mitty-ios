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
    let apiGetInvitation = MITTY_SERVICE_BASE_URL + "/myinvitation/status"
    let apiAcceptInvitation = MITTY_SERVICE_BASE_URL + "/accept/invitation"
    
    
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
    func sendInvitation(_ type: String, id: Int64, message: String, invitees: [Int]) {

        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]

        let parameters: [String: Any] = [
            "forType": type,
            "idOfType": id,
            "message": message,
            "invitees" : invitees,
        ]

        if let objectData = try? JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
            print(objectString ?? "")
        }
        
        Alamofire.request(apiSendInvitation, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: httpHeaders).validate(statusCode: 200..<300).responseJSON { response in
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
    
    /// <#Description#>
    ///
    /// - Parameter callback: <#callback description#>
    func getMyInvitations (callback: @escaping (_ invitatios: [InvitationInfo]) -> Void) {
        
        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]
        
        LoadingProxy.on()
        
        // ダミーコード、本当はサーバーから検索する。
        var invitations = [InvitationInfo]()
        let request = Alamofire.request(apiGetInvitation, method: .get, headers: httpHeaders)
        request.validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                LoadingProxy.off()
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    print(json)
                    
                    if (json == nil || json["invitationStatus"] == nil) {
                        callback([])
                        return
                    }
                    
                    for (_, jsonInfo) in json["invitationStatus"] {
                        invitations.append(self.bindInvitation(jsonInfo))
                    }
                    callback(invitations)
                }
                
            case .failure(let error):
                print(error)
                print(super.jsonResponse(response))
                LoadingProxy.off()
            }
        }
        
    }
    
    
    func accept (_ invitation: InvitationInfo , status: String) {
        
        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]
        
        let parameters:[String: Any] = [
            "invitation_id": invitation.id,
            "invitees_id": invitation.inviteesID,
            "reply_status" : status
        ]
        
        print(parameters)
        
        LoadingProxy.on()
        
        // ダミーコード、本当はサーバーから検索する。
        
        let request = Alamofire.request(apiAcceptInvitation, method: .post, parameters: parameters, headers: httpHeaders)
        request.validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                LoadingProxy.off()
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    print(json)
                    
                    if (json == nil || json["ok"] == nil) {
                        return
                    }
                }
                
            case .failure(let error):
                print(error)
                print(super.jsonResponse(response))
                LoadingProxy.off()
            }
        }
        
    }
    
    /// <#Description#>
    ///
    /// - Parameter json: <#json description#>
    /// - Returns: <#return value description#>
    func bindInvitation(_ json: JSON) -> InvitationInfo {
        let invitation = InvitationInfo()
        invitation.id = json["id"].int64Value
        invitation.invitaterID = json["invitater_id"].intValue
        invitation.forType = json["for_type"].stringValue
        invitation.idOfType = json["id_of_type"].int64Value
        invitation.invitationTitle = json["invitation_title"].stringValue
        invitation.message = json["message"].stringValue
        invitation.timeOfInvitation = json["time_of_invitation"].stringValue.utc2Date()
        invitation.inviteesID = json["invitees_id"].int64Value
        
        invitation.replyStatus = json["reply_status"].stringValue
        
        return invitation
    }
}
