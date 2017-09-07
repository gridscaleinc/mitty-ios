//
//  OffersService.swift
//  mitty
//
//  Created by gridscale on 2017/09/01.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

import SwiftyJSON

// シングルトンサービスクラス。
class OffersService: Service {
    let apiSendOffer = MITTY_SERVICE_BASE_URL + "/send/offers"
    let apiOfferList = MITTY_SERVICE_BASE_URL + "/myoffers"
    let apiAcceptOffer = MITTY_SERVICE_BASE_URL + "/accept/offers"


    static var instance: OffersService = {
        let instance = OffersService()
        return instance
    }()

    private override init() {

    }

    /// サーバーにいいねを送信。
    ///
    /// - Parameters:
    ///   - type: いいね対象タイプ。(EVENT/REQUEST/PROPOSAL)
    ///   - id: いいね対象ID。
    func sendNameCardOffer(_ offer: Offer) {

        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]

        let parmeters: [String: Any] = [
            "to_mitty_id": offer.toMittyId,
            "type": "NAMECARD",
            "message": offer.message,
            "reply_status": "NONE",
            "offerred_id": offer.offerredId,
            "replied_id": offer.repliedId
        ]

        Alamofire.request(apiSendOffer, method: .post, parameters: parmeters, headers: httpHeaders).validate(statusCode: 200..<300).responseJSON { response in
            LoadingProxy.off()
            switch response.result {
            case .success:
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    print(json)
                    if (json == nil || json["id"] == nil) {
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
    func getMyOffers (callback: @escaping (_ offers: [Offer]) -> Void) {

        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]

        LoadingProxy.on()

        // ダミーコード、本当はサーバーから検索する。
        var offers = [Offer]()
        let request = Alamofire.request(apiOfferList, method: .get, headers: httpHeaders)
        request.validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                LoadingProxy.off()
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    print(json)

                    if (json == nil || json["offerList"] == nil) {
                        callback([])
                        return
                    }

                    for (_, jsonOffer) in json["offerList"] {
                        offers.append(self.bindOffers(jsonOffer))
                    }
                    callback(offers)
                }

            case .failure(let error):
                print(error)
                print(super.jsonResponse(response))
                LoadingProxy.off()
            }
        }

    }

    
    func accept (_ offer: Offer , status: String) {
        
        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]
        
        let parameters:[String: Any] = [
            "id": offer.id,
            "to_mitty_id": offer.toMittyId,
            "offerred_id" : offer.offerredId,
            "type": offer.type,
            "message": offer.message,
            "reply_status" : status
        ]
        
        LoadingProxy.on()
        
        // ダミーコード、本当はサーバーから検索する。
        
        let request = Alamofire.request(apiAcceptOffer, method: .post, parameters: parameters, headers: httpHeaders)
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
    func bindOffers(_ json: JSON) -> Offer {
        let offer = Offer()
        offer.id = json["id"].int64Value
        offer.type = json["type"].stringValue
        offer.fromMittyId = json["from_mitty_id"].intValue
        offer.toMittyId = json["to_mitty_id"].intValue
        offer.message = json["message"].stringValue
        offer.repliedStatus = json["replied_status"].stringValue
        offer.offerredId = json["offerred_id"].int64Value

        offer.repliedStatus = json["replied_status"].stringValue


        return offer
    }
}
