//
//  LikesService.swift
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
class LikesService {
    let apiSendLike = MITTY_SERVICE_BASE_URL + "/send/like"
    let apiRemoveLike = MITTY_SERVICE_BASE_URL + "/remove/like"
    
    static var instance : LikesService = {
        let instance = LikesService()
        return instance
    }()
    
    private init() {
        
    }
    
    // サーバーにいいねを送信。
    func sendLike(_ type :String, id : Int64) {
        
        let httpHeaders = [
            "X-Mitty-AccessToken" : ApplicationContext.userSession.accessToken
        ]
        
        let parmeters : [String : Any] = [
            "type" : type,
            "id" : id
        ]
        
        Alamofire.request(apiSendLike, method: .post, parameters: parmeters, headers : httpHeaders ).validate(statusCode: 200..<300).responseJSON { response in
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
                }
        }
    }
    
    // サーバーにいいねを削除。
    func removeLike(_ type :String, id : Int64) {
        
        let httpHeaders = [
            "X-Mitty-AccessToken" : ApplicationContext.userSession.accessToken
        ]
        
        let parameters : [String : Any] = [
            "type" : type,
            "id" : id
        ]
        
        Alamofire.request(apiRemoveLike, method: .post
            , parameters: parameters, headers : httpHeaders ).validate(statusCode: 200..<300).responseJSON { response in
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
                }
        }
    }
}
