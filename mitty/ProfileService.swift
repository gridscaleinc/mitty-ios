//
//  ProfileService.swift
//  mitty
//
//  Created by gridscale on 2017/08/15.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//


import Foundation
import UIKit
import Alamofire
import AlamofireImage

import SwiftyJSON

// シングルトンサービスクラス。
class ProfileService: Service {
    let apiMyProfile = MITTY_SERVICE_BASE_URL + "/myprofile"
    let userProfileUrl = MITTY_SERVICE_BASE_URL + "/user/profile"
    let apiSaveProfile = MITTY_SERVICE_BASE_URL + "/save/profile"

    static var instance: ProfileService = {
        let instance = ProfileService()
        return instance
    }()

    private override init() {

    }

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - profile: <#profile description#>
    ///   - onComplete: <#onComplete description#>
    ///   - onError: <#onError description#>
    func saveProfile(_ profile: Profile, onComplete: @escaping () -> Void, onError: @escaping (_ err: String) -> Void) {
        
        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]

        let parameters: [String: Any] = [
            "id": profile.id,

            "mitty_id": profile.mittyId,
            "gender": profile.gender,
            "one_word_speech": profile.oneWordSpeech,
            "constellation": profile.constellation,
            "home_island_id": profile.homeIslandId,
            "birth_island_id": profile.birthIslandId,
            "age_group": profile.ageGroup,
            "appearance_tag": profile.appearanceTag,
            "occupation_tag1": profile.occupationTag1,
            "occupation_tag2": profile.occupationTag2,
            "occupation_tag3": profile.occupationTag3,
            "hobby_tag1": profile.hobbyTag1,
            "hobby_tag2": profile.hobbyTag2,
            "hobby_tag3": profile.hobbyTag3,
            "hobby_tag4": profile.hobbyTag4,
            "hobby_tag5": profile.hobbyTag5,
        ]

        LoadingProxy.on()
        Alamofire.request(apiSaveProfile, method: .post, parameters: parameters, headers: httpHeaders).validate(statusCode: 200..<300).responseJSON { response in
            LoadingProxy.off()
            switch response.result {
            case .success:
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    print(json)
                    if (json == nil || json["id"] == nil) {
                        return
                    }
                    let id = json["id"].int64Value
                    profile.id = id
                    onComplete()
                    return
                }

                break

            case .failure(let error):
                print(error)
                onError(error.localizedDescription)
                print(super.jsonResponse(response))
                LoadingProxy.off()
            }
        }
    }

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - onComplete: <#onComplete description#>
    ///   - onError: <#onError description#>
    func myProfile(onComplete: @escaping (_ profile: Profile) -> Void, onError: @escaping (_ error: String) -> Void) {

        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]

        LoadingProxy.on()

        Alamofire.request(apiMyProfile, method: .get, headers: httpHeaders).validate(statusCode: 200..<300).responseJSON { response in
            LoadingProxy.off()
            switch response.result {
            case .success:
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    print(json)
                    if (json == nil || json["profile"] == nil) {
                        return
                    }
                    let profile = self.bindProfile(json["profile"])
                    onComplete(profile)
                    return
                }

                break

            case .failure(let error):
                print(error)
                onError(error.localizedDescription)
                print(super.jsonResponse(response))
                LoadingProxy.off()
            }
        }
    }

    func profile(of mittyId: Int, onComplete: @escaping (_ profile: Profile) -> Void, onError: @escaping (_ error: String) -> Void) {
        
        let httpHeaders = [
            "X-Mitty-AccessToken": ApplicationContext.userSession.accessToken
        ]
        
        let parameters = [
            "mitty_id": mittyId
        ]
        
        LoadingProxy.on()
        
        Alamofire.request(userProfileUrl, method: .get, parameters: parameters, headers: httpHeaders).validate(statusCode: 200..<300).responseJSON { response in
            LoadingProxy.off()
            switch response.result {
            case .success:
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    print(json)
                    if (json == nil || json["profile"] == nil) {
                        return
                    }
                    let profile = self.bindProfile(json["profile"])
                    onComplete(profile)
                    return
                }
                
                break
                
            case .failure(let error):
                print(error)
                onError(error.localizedDescription)
                print(super.jsonResponse(response))
                LoadingProxy.off()
            }
        }
    }


    func bindProfile(_ json: JSON) -> Profile {

        let result = Profile()
        result.id = json["id"].int64Value
        result.mittyId = json["mitty_id"].intValue
        result.gender = json["gender"].stringValue
        result.ageGroup = json["age_group"].stringValue
        result.oneWordSpeech = json["one_word_speech"].stringValue
        result.constellation = json["constellation"].stringValue
        result.homeIslandId = json["home_island_id"].int64Value
        result.birthIslandId = json["birth_island_id"].int64Value
        result.appearanceTag = json["appearance_tag"].stringValue
        result.occupationTag1 = json["occupation_tag1"].stringValue
        result.occupationTag2 = json["occupation_tag2"].stringValue
        result.occupationTag3 = json["occupation_tag3"].stringValue
        result.hobbyTag1 = json["hobby_tag1"].stringValue
        result.hobbyTag2 = json["hobby_tag2"].stringValue
        result.hobbyTag3 = json["hobby_tag3"].stringValue
        result.hobbyTag4 = json["hobby_tag4"].stringValue
        result.hobbyTag5 = json["hobby_tag5"].stringValue

        return result
    }
}
