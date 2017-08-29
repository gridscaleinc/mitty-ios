//
//  SocialContactService.swift
//  mitty
//
//  Created by gridscale on 2016/11/13.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

// シングルトンサービスクラス。
class SocialContactService: Service {
    static var instance: SocialContactService = {
        let instance = SocialContactService()
        return instance
    }()

    private override init() {

    }

    // サーバーからイベントを検索。
    func search(keys: [String]) -> [SocialContactInfo] {

        // ダミーコード、本当はサーバーから検索する。
        var list = [SocialContactInfo]()
        list.append(buildContact(1))
        list.append(buildContact(2))
        list.append(buildContact(3))
        list.append(buildContact(4))

        return list

    }

    // イベントを生成する
    func buildContact(_ n: Int) -> SocialContactInfo! {

        let imagenames: [String] = ["pengin", "pengin1", "pengin2", "pengin3", "pengin1", "pengin2"]
        let names: [String] = ["Domanthan", "Dongri", "Yang", "Choii", "Lee", "Jack Ma"]

        let a = SocialContactInfo()
        a.name = names[n]
        a.imageUrl = imagenames[n]

        return a
    }


    /// <#Description#>
    ///
    /// - Parameters:
    ///   - mittyId: <#mittyId description#>
    ///   - onComplete: <#onComplete description#>
    ///   - onError: <#onError description#>
    func contactedNamecards(of mittyId: Int, onComplete: @escaping (_ cardList: [ContacteeNamecard]) -> Void, onError: @escaping (_ error: String) -> Void) {
        
        let url = MITTY_SERVICE_BASE_URL + "/contactee/namecards"
        
        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]
        
        let parameters = [
            "mitty_id": mittyId
        ]

        LoadingProxy.on()
        
        Alamofire.request(url, method: .get, parameters: parameters, headers: httpHeaders).validate(statusCode: 200..<300).responseJSON { response in
            LoadingProxy.off()
            switch response.result {
            case .success:
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    print(json)
                    if (json == nil || json["contacteeNamecards"] == nil) {
                        return
                    }
                    let nameCardInfoList = self.bindContacteeNamecards(json)
                    onComplete(nameCardInfoList)
                    return
                }
                
                break
                
            case .failure(let error):
                print(error)
                print(super.jsonResponse(response))
                onError(error.localizedDescription)
            }
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameter json: <#json description#>
    /// - Returns: <#return value description#>
    func bindContacteeNamecards(_ json: JSON) -> [ContacteeNamecard] {
        
        var results : [ContacteeNamecard] = []
        
        for (_, info) in json["contacteeNamecards"] {
            let card = ContacteeNamecard()
            bindItem(card, info)
            results.append(card)
        }
        
        return results
        
    }
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - card: <#card description#>
    ///   - json: <#json description#>
    func bindItem (_ card: ContacteeNamecard, _ json :JSON) {
        card.namecardID = json["name_card_id"].int64Value
        card.contactID = json["contact_id"].int64Value
        card.businessName = json["business_name"].stringValue
        card.businessLogoUrl = json["business_logo_url"].stringValue
        card.relatedEventID = json["related_event_id"].int64Value
        card.contctedDate = json["contacted_date"].stringValue.utc2Date()
    }

}
