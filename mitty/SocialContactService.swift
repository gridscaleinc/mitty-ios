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

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - onComplete: <#onComplete description#>
    ///   - onError: <#onError description#>
    func getContacteeList(onComplete: @escaping (_ contacteeList: [Contactee])->Void, onError: @escaping (_ error: String) -> Void) {
        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]
        
        LoadingProxy.on()
        
        let api = APIClient(path: "/contact/list", method: .get, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            if (json == nil || json["contacteeList"] == nil) {
                return
            }
            let contacteeList = self.bindContacteeList(json)
            onComplete(contacteeList)
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })
        
    }

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - mittyId: <#mittyId description#>
    ///   - onComplete: <#onComplete description#>
    ///   - onError: <#onError description#>
    func contactedNamecards(of mittyId: Int, onComplete: @escaping (_ cardList: [ContacteeNamecard]) -> Void, onError: @escaping (_ error: String) -> Void) {
        
        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]
        
        let parameters = [
            "mitty_id": mittyId
        ]

        LoadingProxy.on()
        
        let api = APIClient(path: "/contactee/namecards", method: .get, parameters: parameters, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            if (json == nil || json["contacteeNamecards"] == nil) {
                return
            }
            let nameCardInfoList = self.bindContacteeNamecards(json)
            onComplete(nameCardInfoList)
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })
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
    
    /// <#Description#>
    ///
    /// - Parameter json: <#json description#>
    /// - Returns: <#return value description#>
    func bindContacteeList (_ json: JSON) -> [Contactee] {
        var result = [Contactee]()
        
        let profileService = ProfileService.instance
        
        for (_, contactee) in json["contacteeList"] {
            let contact = Contactee()
            contact.contactee_name = contactee["contactee_name"].stringValue
            contact.contactee_icon = contactee["contactee_icon"].stringValue
            let profile = profileService.bindProfile(contactee)
            contact.profile = profile
            
            result.append(contact)
        }
        
        return result
        
    }
    
    func getSocailMirror(onComplete: @escaping (_ mirror: SocialMirror) -> Void, onError: @escaping (_ error: String) -> Void) {
        
        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]
        
        LoadingProxy.on()
        
        let api = APIClient(path: "/social/mirror", method: .get, headers: httpHeaders)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            if (json == nil || json["todaysEvent"] == nil) {
                return
            }
            let mirror = self.bindSocialMirror(json)
            onComplete(mirror)
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })
    }
    

    /// <#Description#>
    ///
    /// - Parameter json: <#json description#>
    /// - Returns: <#return value description#>
    func bindSocialMirror( _ json: JSON) -> SocialMirror {
        let m = SocialMirror()
        m.event = json["event"].intValue
        m.todaysEvent = json["todaysEvent"].intValue
        m.eventInvitation = json["eventInvitation"].intValue
        m.businesscardOffer = json["businessCardOffer"].intValue
        m.request = json["request"].intValue
        m.proposal = json["proposal"].intValue

        return m
        
    }
}
