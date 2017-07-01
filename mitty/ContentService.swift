//
//  ContentService.swift
//  mitty
//
//  Created by gridscale on 2017/06/30.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

// シングルトンサービスクラス。
class ContentService {
    let apiUploadContent = "http://dev.mitty.co/api/upload/content"
    
    static var instance : ContentService = {
        let instance = ContentService()
        return instance
    }()
    
    private init() {
        
    }
    
    // サーバーからイベントを検索。
    func uploadContent(img : UIImage,  onCompletion : @escaping(_ : Int64 ) -> Void) {
        
        let imageData:NSData = UIImagePNGRepresentation(img)! as NSData
        let strBase64 = imageData.base64EncodedString()
        
        let parameters = [
            "mime": "image/png",
            "name": String(format: "icon"),
            "data": strBase64
        ]
        
        let httpHeaders = [
            "X-Mitty-AccessToken" : ApplicationContext.userSession.accessToken
        ]
        
        print(parameters)
        print(httpHeaders)
        

        Alamofire.request(apiUploadContent, method: .post, parameters: parameters, encoding: JSONEncoding.default
            , headers : httpHeaders ).validate(statusCode: 200..<300).responseJSON { response in
                LoadingProxy.off()
                switch response.result {
                case .success:
                    if let jsonObject = response.result.value {
                        let json = JSON(jsonObject)
                        print(json)
                        if (json == nil || json["contentId"] == nil) {
                            return
                        }
                        
                        let contentId = json["contentId"].int64Value
                        onCompletion(contentId)
                        
                        return
                    }

                    break
                    
                case .failure(let error):
                    print(error)
                }
        }
    }
}
