//
//  Service.swift
//  mitty
//
//  Created by gridscale on 2016/10/30.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//


import Foundation
import Alamofire

// Serverとの通信を使う
func SignUp(username: String, password: String) {
    let params = [
        "username": username,
        "password": password
    ]
    Alamofire.request("http://dev.mitty.co/api/signup", method: .post, parameters: params, encoding: URLEncoding.default).responseJSON { response in
        debugPrint(response)
        if let json = response.result.value {
            print("JSON: \(json)")
        }
    }
}

func SignIn(username: String, password: String) {
    let params = [
        "username": username,
        "password": password
    ]
    Alamofire.request("http://dev.mitty.co/api/signin", method: .post, parameters: params, encoding: URLEncoding.default).responseJSON { response in       debugPrint(response)
        if let json = response.result.value {
            print("JSON: \(json)")
        }
    }
}

// 
//
class JSONRequest  {
    
    var parameters : [String : Any] = [:]
    
    //
    //
    func setStr(named name : String, value: String?) {
        parameters[name] = value
    }

    //
    //
    func setInt(named name : String, value: String?) {
        if (value == nil || value == "") {
            parameters[name] = nil
            return
        }
        
        let num = NSNumber(value: Int64(value!)!)
        parameters[name] = num
    }
    
    func setDouble(named name: String, value : String?) {
        if (value == nil || value == "") {
            parameters[name] = nil
            return
        }
        
        let num = NSNumber(value: Double(value!)!)
        parameters[name] = num

    }
    
    func setBool(named name: String, value : Bool) {
        if (value) {
            parameters[name] = "true"
        } else {
            parameters[name] = "false"
        }
        
    }
    
    func setDate(named name: String, date: Date) {
        setStr(named: name, value: date.iso8601UTC)
    }

    //
    func has(named name: String) -> Bool {
        return parameters[name] != nil
    }
    
    func mandatory(name: String) {
        assert(has(named: name))
    }
    
    func isInt(named name: String) -> Bool {
        if (parameters[name] is NSNumber) {
            let n = parameters[name] as! NSNumber
            return (n.isEqual(to: NSNumber(value: n.int64Value)))
        }
        return false
    }

    func isBool(named name: String) -> Bool {
        if (parameters[name] is String) {
            let s = parameters[name] as! String
            return (s == "true" || s == "false")
        }
        return false
    }
    
}




