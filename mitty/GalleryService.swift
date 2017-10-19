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
        
        let api = APIClient(path: "/gallery/contents", method: .get, parameters: parameters)
        api.request(success: { (data: Dictionary) in
            LoadingProxy.off()
            let jsonObject = data
            let json = JSON(jsonObject)
            if (json == nil || json["galleryContents"] == nil) {
                return
            }
            let contents = self.bindContents(json["galleryContents"])
            onCompletion(contents)
        }, fail: {(error: Error?) in
            print(error as Any)
            LoadingProxy.off()
        })

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
