//
//  UserSession.swift
//  mitty
//
//  Created by gridscale on 2017/05/16.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

class UserSession {
    static let ID = "USER-SESSION"
    var userDatas: [String: Any] = [:]

    var userId: Int {
        get {
            if let v = userDatas["userId"] as? NSNumber {
                return v.intValue
            }
            return 0
        }

        set (v) {
            userDatas["userId"] = NSNumber(value: v)
        }
    }

    var userName: String {
        get { return userDatas["userName"] as! String }
        set (v) { userDatas["userName"] = v }
    }


    var accessToken: String {
        get {
            let aa = userDatas["accessToken"]
            if aa != nil { return aa as! String
            }
            return "-"
        }

        set (v) { userDatas["accessToken"] = v }
    }


    var isFirstTime: Bool {
        get {
            if let v = userDatas["isFirstTime"] as? NSNumber {
                return v.boolValue
            }
            return true
        }

        set (v) {
            userDatas["isFirstTime"] = NSNumber(value: v)
        }
    }

    var isLogedIn: Bool {
        get {
            if let v = userDatas["isLogedIn"] as? NSNumber {
                return v.boolValue
            }
            return false
        }

        set (v) {
            userDatas["isLogedIn"] = NSNumber(value: v)
        }
    }


    var accessCount: Int {
        get {
            if let v = userDatas["accessCount"] as? NSNumber {
                return v.intValue
            }
            return 0
        }

        set (v) {
            userDatas["accessCount"] = NSNumber(value: v)
        }

    }

}
