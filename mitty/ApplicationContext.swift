//
//  ApplicationContext.swift
//  mitty
//
//  Created by gridscale on 2016/10/30.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

///
/// アプリケーションの各機能間にデータを容易に引き渡すための機構。
///
class ApplicationContext {
    static var uiApplication:UIApplication? = nil;
    
    static var userSession = UserSession()
    
    static var config : UserDefaults = UserDefaults.standard
    
    static var skipGuideView = false
    
    //
    static func startUp() {
        
        // 設定値の取得
        // 存在しないキーはnilが返る
        if let sessionData = config.object(forKey: UserSession.ID) as? [String:Any] {
            ApplicationContext.userSession.userDatas = sessionData
            ApplicationContext.userSession.accessCount =  ApplicationContext.userSession.accessCount + 1
            skipGuideView = true
        } else {
            userSession.accessCount = 1
            userSession.userName = ""
            userSession.userId = 0
            userSession.isLogedIn = false
            userSession.accessToken = ""
        }
        saveSession()
        
    }
    
    static func saveSession () {
        config.set(userSession.userDatas, forKey: UserSession.ID)
        config.synchronize()
    }
    
    static func killSession() {
        config.removeObject(forKey: UserSession.ID)
        userSession = UserSession()
        userSession.accessCount = 1
        saveSession()
    }
}
