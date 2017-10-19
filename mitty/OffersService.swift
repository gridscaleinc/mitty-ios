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

        let parameters: [String: Any] = [
            "to_mitty_id": offer.toMittyId,
            "type": "NAMECARD",
            "message": offer.message,
            "reply_status": "NONE",
            "offerred_id": offer.offerredId,
            "replied_id": offer.repliedId
        ]
        
        let api = APIClient(path: "/send/offers", method: .post, parameters: parameters, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            if (json == nil || json["id"] == nil) {
                return
            }
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })
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
        let api = APIClient(path: "/myoffers", method: .get, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            if (json == nil || json["offerList"] == nil) {
                callback([])
                return
            }
            for (_, jsonOffer) in json["offerList"] {
                offers.append(self.bindOffers(jsonOffer))
            }
            callback(offers)
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })

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
        let api = APIClient(path: "/accept/offers", method: .post, parameters: parameters, headers: httpHeaders)
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
