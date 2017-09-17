//
//  GalleryService.swift
//  mitty
//
//  Created by gridscale on 2017/09/17.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

// シングルトンサービスクラス。
class GalleryService: Service {
    let apiGalleryContents = MITTY_SERVICE_BASE_URL + "/gallery/contents"
    
    static var instance: GalleryService = {
        let instance = GalleryService()
        return instance
    }()
    
    private override init() {
        
    }
    
    /// サーバーからイベントを検索。
    ///
    ///
    /// - Parameter onCompletion: 処理結果を渡すコールバック。
    func galleryContents(of id: Int64, onCompletion: @escaping(_: [GalleryContent]) -> Void) {
        
        let parameters: [String: Any] = [
            "id": id
        ]
        
        Alamofire.request(apiGalleryContents, method: .get, parameters: parameters).validate(statusCode: 200..<300).responseJSON { response in
                LoadingProxy.off()
                switch response.result {
                case .success:
                    if let jsonObject = response.result.value {
                        let json = JSON(jsonObject)
                        print(json)
                        if (json == nil || json["galleryContents"] == nil) {
                            return
                        }
                        
                        let contents = self.bindContents(json["galleryContents"])
                        onCompletion(contents)
                        
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
    
    /// contents -> [Content]バインド。
    ///
    ///
    /// - Parameter contents: JSON
    /// - Returns: コンテントオブジェクト一覧。
    func bindContents(_ contents: JSON) -> [GalleryContent] {
        
        var result = [GalleryContent]()
        for (_, content) in contents {
            let c = GalleryContent()
            // TODO.. 幾つの項目はbindingされてない。
            c.galleryID = content["gallery_id"].int64Value
            c.caption = content["caption"].stringValue
            c.briefInfo = content["brief_info"].stringValue
            c.freeText = content["free_text"].stringValue
            
            // TODO.. 幾つの項目はbindingされてない。
            c.contentId = content["id"].int64Value
            c.name = content["name"].stringValue
            c.linkURL = content["link_url"].stringValue
            result.append(c)
        }
        
        return result
    }
    
}
