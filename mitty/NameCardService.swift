//
//  NameCardService.swift
//  mitty
//
//  Created by gridscale on 2017/08/21.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

import SwiftyJSON

// シングルトンサービスクラス。
class NameCardService: Service {
    static var instance: NameCardService = {
        let instance = NameCardService()
        return instance
    }()
    
    private override init() {
        
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - NameCard: <#NameCard description#>
    ///   - onComplete: <#onComplete description#>
    ///   - onError: <#onError description#>
    func saveNameCard(_ nameCard: NameCard, onComplete: @escaping () -> Void, onError: @escaping (_ err: String) -> Void) {
        
        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]
        
        let parameters: [String: Any] = [
            "id": nameCard.id,
            "mitty_id": ApplicationContext.userSession.userId,
            "name": nameCard.name,
            "business_name": nameCard.businessName,
            "webpage": nameCard.webpage,
            "business_sub_name": nameCard.businessSubName,
            "business_logo_id": nameCard.businessLogoId,
            "business_title": nameCard.businessTitle,
            "address_line1": nameCard.addressLine1,
            "address_line2": nameCard.addressLine2,
            "email": nameCard.email,
            "phone": nameCard.phone,
            "mobile_phone": nameCard.mobilePhone,
            "fax": nameCard.fax,
            ]
        
        LoadingProxy.on()
        
        let api = APIClient(path: "/save/namecard", method: .post, parameters: parameters, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            if (json == nil || json["id"] == nil) {
                return
            }
            let id = json["id"].int64Value
            nameCard.id = id
            onComplete()
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - onComplete: <#onComplete description#>
    ///   - onError: <#onError description#>
    func myNameCard(onComplete: @escaping (_ cardList: [NameCardInfo]) -> Void, onError: @escaping (_ error: String) -> Void) {
        
        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]
        
        LoadingProxy.on()
        
        let api = APIClient(path: "/mynamecards", method: .get, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            if (json == nil || json["namecards"] == nil) {
                return
            }
            let nameCardInfoList = self.bindNameCards(json)
            onComplete(nameCardInfoList)
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - onComplete: <#onComplete description#>
    ///   - onError: <#onError description#>
    func getNamecard(of id: Int64, onComplete: @escaping (_ card: NameCardInfo) -> Void, onError: @escaping (_ error: String) -> Void) {
        
        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]
        
        let parameters = [
            "id": id
        ]
        
        LoadingProxy.on()
        
        let api = APIClient(path: "/namecard/of", method: .get, parameters: parameters, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            if (json == nil || json["namecard"] == nil) {
                return
            }
            let nameCardInfo = self.bindNameCard(json["namecard"])
            onComplete(nameCardInfo)
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })
    }
    
    
    /// <#Description#>
    ///
    /// - Parameter json: <#json description#>
    /// - Returns: <#return value description#>
    func bindNameCards(_ json: JSON) -> [NameCardInfo] {
        var results : [NameCardInfo] = []
        
        for (_, info) in json["namecards"] {
            let result = bindNameCard(info)
            results.append(result)
        }
        
        return results
        
    }
    
    /// <#Description#>
    ///
    /// - Parameter json: <#json description#>
    /// - Returns: <#return value description#>
    func bindNameCard(_ json: JSON) -> NameCardInfo {
        
        let result = NameCardInfo()
        result.businessLogoUrl = json["business_logo_url"].stringValue
        bindItem(result, json)
        return result
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - result: <#result description#>
    ///   - json: <#json description#>
    func bindItem (_ result: NameCard, _ json :JSON) {
        result.id = json["id"].int64Value
        result.mittyId = json["mitty_id"].intValue
        result.name = json["name"].stringValue
        result.businessName = json["business_name"].stringValue
        result.businessLogoId = json["business_logo_id"].int64 ?? 0
        result.businessSubName = json["business_sub_name"].stringValue
        result.businessTitle = json["business_title"].stringValue
        result.webpage = json["webpage"].stringValue
        result.email = json["email"].stringValue
        result.addressLine1 = json["address_line1"].stringValue
        result.addressLine2 = json["address_line2"].stringValue
        result.phone = json["phone"].stringValue
        result.mobilePhone = json["mobile_phone"].stringValue
        result.fax = json["fax"].stringValue
    }
}
