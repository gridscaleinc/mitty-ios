//
//  ProposalService.swift
//  mitty
//
//  Created by gridscale on 2017/08/12.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/// 提案サービス。
class ProposalService: Service {
    let urlMyrequest = MITTY_SERVICE_BASE_URL + "/myproposal"
    let registerUrl = MITTY_SERVICE_BASE_URL + "/new/proposal"
    let proposalsOfUrl = MITTY_SERVICE_BASE_URL + "/proposals/of"
    let acceptUrl = MITTY_SERVICE_BASE_URL + "/accept/proposal"
    let approveUrl = MITTY_SERVICE_BASE_URL + "/approve/proposal"
    
    
    static var instance: ProposalService = {
        let instance = ProposalService()
        return instance
    }()

    private override init() {

    }

    /// 提案を登録。
    ///
    /// - Parameters:
    ///   - req: 送信情報オブジェクト。
    ///   - onSuccess: 正常時の呼び出し処理。
    ///   - onError: エラー時の呼び出し処理。
    func register(_ req: NewProposalReq, onSuccess: @escaping ((_ id: Int64) -> Void), onError: @escaping ((_ error: String) -> Void)) {

        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]

        LoadingProxy.on()

        print(req.parameters)

        Alamofire.request(registerUrl, method: .post, parameters: req.parameters, headers: httpHeaders).validate(statusCode: 200..<300).responseJSON { response in

            LoadingProxy.off()

            switch response.result {
            case .success:
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    print(json)

                    let proposalId = json["id"].int64Value
                    onSuccess(proposalId)
                    
                    print(proposalId)

                }

            case .failure(let error):
                print(error)
                let jsonRes = super.jsonResponse(response)
                
                print(jsonRes)
                LoadingProxy.off()
                onError("error occoured\(jsonRes)")
            }
            
        }

    }

    func accept(_ proposal: ProposalInfo, status: AcceptStatus, onSuccess: @escaping (() -> Void), onError: @escaping ((_ error: String) -> Void)) {
        
        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]
        
        LoadingProxy.on()
        
        let parameters: [String: Any] = [
            "proposal_id": proposal.id,
            "confirm_tel": proposal.confirmTel,
            "confirm_email": proposal.confirmEmail,
            "status": status.rawValue,
            ]
        
        Alamofire.request(acceptUrl, method: .post, parameters: parameters, headers: httpHeaders).validate(statusCode: 200..<300).responseJSON { response in
            
            LoadingProxy.off()
            
            switch response.result {
            case .success:
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    print(json)
                    
                    let proposalId = json["id"].stringValue
                    
                    print(proposalId)
                    
                }
                onSuccess()
                
            case .failure(let error):
                print(error)
                let jsonRes = super.jsonResponse(response)
                
                print(jsonRes)
                LoadingProxy.off()
                onError("error occoured\(jsonRes)")
            }
            
        }
        
    }
    
    func approve(_ proposal: ProposalInfo, status: ApprovalStatus, onSuccess: @escaping (() -> Void), onError: @escaping ((_ error: String) -> Void)) {
        
        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]
        
        LoadingProxy.on()
        
        let parameters: [String: Any] = [
            "proposal_id": proposal.id,
            "status": status.rawValue,
            ]
        
        Alamofire.request(approveUrl, method: .post, parameters: parameters, headers: httpHeaders).validate(statusCode: 200..<300).responseJSON { response in
            
            LoadingProxy.off()
            
            switch response.result {
            case .success:
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    print(json)
                    
                    let proposalId = json["id"].stringValue
                    
                    print(proposalId)
                    
                }
                onSuccess()
                
            case .failure(let error):
                print(error)
                let jsonRes = super.jsonResponse(response)
                
                print(jsonRes)
                LoadingProxy.off()
                onError("error occoured\(jsonRes)")
            }
            
        }
        
    }

    /// 自分の提案一覧を取得。
    ///
    /// - Parameters:
    ///   - key: フィルタキー。
    ///   - callback: コールバック。
    func getMyProposals (key: String, callback: @escaping (_ proposals: [ProposalInfo]) -> Void) {
        let parmeters: [String: Any] = [
            "q": key,
        ]

        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]

        LoadingProxy.on()

        // ダミーコード、本当はサーバーから検索する。
        var proposals = [ProposalInfo]()
        let request = Alamofire.request(urlMyrequest, method: .get, parameters: parmeters, headers: httpHeaders)
        request.validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                LoadingProxy.off()
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    print(json)

                    if (json == nil || json["proposals"] == nil) {
                        callback([])
                        return
                    }

                    for (_, jsonReq) in json["proposals"] {
                        proposals.append(self.bindProposalInfo(jsonReq))
                    }
                    callback(proposals)
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
    /// - Parameters:
    ///   - req: <#req description#>
    ///   - callback: <#callback description#>
    func getProposalsOf (reqId: Int64, callback: @escaping (_ proposals: [ProposalInfo]) -> Void) {
        let parmeters: [String: Any] = [
            "requestId": reqId,
            ]
        
        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]
        
        LoadingProxy.on()
        
        // ダミーコード、本当はサーバーから検索する。
        var proposals = [ProposalInfo]()
        let request = Alamofire.request(proposalsOfUrl, method: .get, parameters: parmeters, headers: httpHeaders)
        request.validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                LoadingProxy.off()
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    print(json)
                    
                    if (json == nil || json["proposals"] == nil) {
                        callback([])
                        return
                    }
                    
                    for (_, jsonReq) in json["proposals"] {
                        proposals.append(self.bindProposalInfo(jsonReq))
                    }
                    callback(proposals)
                }
                
            case .failure(let error):
                LoadingProxy.off()
                print(super.jsonResponse(response))
                print(error)
            }
        }
        
    }

    
    /// 提案オブジェクトバインド。
    ///
    /// - Parameter json: JSON
    /// - Returns: 提案情報。
    func bindProposalInfo(_ json: JSON) -> ProposalInfo {
        let info = ProposalInfo()

        info.id = json["id"].int64Value
        info.replyToRequestID = json["reply_to_request_id"].int64Value
        info.contactTel = json["contact_tel"].stringValue
        info.contactEmail = json["contact_email"].stringValue
        info.proposedIslandID = json["proposed_island_id"].int64Value
        info.proposedIslandID2 = json["proposed_island_id2"].int64Value
        info.galleryID = json["gallery_id"].int64Value
        info.priceName1 = json["priceName1"].stringValue
        info.price1 = json["price1"].int64Value
        info.priceName2 = json["priceName2"].stringValue
        info.price2 = json["price2"].int64Value
        info.priceCurrency = json["price_currency"].stringValue
        info.priceInfo = json["price_info"].stringValue
        info.proposedDatetime1 = json["proposed_datetime1"].stringValue.utc2Date()
        info.proposedDatetime2 = json["proposed_datetime2"].stringValue.utc2Date()
        info.additionalInfo = json["additional_info"].stringValue
        info.proposerId = json["proposer_id"].intValue
        info.proposerInfo = json["proposer_info"].stringValue
        info.additionalInfo = json["additional_info"].stringValue
        info.confirmTel = json["confirm_tel"].stringValue
        info.confirmEmail = json["confirm_email"].stringValue
        
        info.acceptStatus = json["accept_status"].stringValue
        info.acceptDatetime = json["accept_datetime"].stringValue.utc2Date()
        
        info.approvalDate = json["approval_date"].stringValue.utc2Date()
        info.approvalStatus = json["approval_status"].stringValue
        
        // other info
        info.islandName = json["island_name"].stringValue
        info.proposerName = json["proposer_name"].stringValue
        info.proposerIconUrl = json["proposer_icon_url"].stringValue
        info.numberOfLikes = json["num_of_likes"].intValue

        return info
    }
    
    

}
