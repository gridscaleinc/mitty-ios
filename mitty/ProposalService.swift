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

class ProposalService {
    let urlMyrequest = MITTY_SERVICE_BASE_URL + "/myproposal"
    
    static var instance : ProposalService = {
        let instance = ProposalService()
        return instance
    }()
    
    private init() {
        
    }
    
    func getMyProposals (key : String, callback: @escaping (_ request: [ProposalInfo]) -> Void ) {
        let parmeters : [String : Any] = [
            "q" : key,
            ]
        
        let httpHeaders = [
            "X-Mitty-AccessToken" : ApplicationContext.userSession.accessToken
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
                    
                    for ( _, jsonReq) in json["proposals"] {
                        proposals.append(self.bindProposalInfo(jsonReq))
                    }
                    callback(proposals)
                }
                
            case .failure(let error):
                LoadingProxy.off()
                print(error)
            }
        }
        
    }
    
    func bindProposalInfo(_ json: JSON) -> ProposalInfo {
        let info = ProposalInfo()
        
        info.replyToRequestID  = json["reply_to_request_id"].int64Value
        info.contactTel        = json["contact_tel"].stringValue
        info.contactEmail      = json["contact_email"].stringValue
        info.proposedIslandID  = json["proposed_island_id"].int64Value
        info.proposedIslandID2 = json["proposed_island_id2"].int64Value
        info.galleryID         = json["gallery_id"].int64Value
        info.priceName1        = json["priceName1"].stringValue
        info.price1            = json["price1"].int64Value
        info.priceName2        = json["priceName2"].stringValue
        info.price2            = json["price2"].int64Value
        info.priceCurrency     = json["price_currency"].stringValue
        info.priceInfo         = json["price_info"].stringValue
        info.proposedDatetime1 = json["proposed_datetime1"].stringValue
        info.proposedDatetime2 = json["proposed_datetime2"].stringValue
        info.additionalInfo    = json["additional_info"].stringValue
        info.proposerInfo      = json["proposer_info"].stringValue
        info.confirmTel        = json["confirm_tel"].stringValue
        info.confirmEmail      = json["confirm_email"].stringValue
        
        return info
    }

}
