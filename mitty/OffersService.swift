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
    func sendNameCardOffer(_ offer: NamecardOffer) {

        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]

        let parmeters: [String: Any] = [
            "to_mitty_id": offer.toMittyId,
            "type": "NAMECARD",
            "message": offer.message,
            "reply_status": "NONE",
            "offerred_id": offer.offerredId,
            "replied_id": offer.disiredId
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
}
