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
    Alamofire.request("http://dev.mitty.co/api/signup").responseJSON { response in
        debugPrint(response)
        if let json = response.result.value {
            print("JSON: \(json)")
        }
    }
}

func SignIn(username: String, password: String) {
    Alamofire.request("http://dev.mitty.co/api/signin").responseJSON { response in
        debugPrint(response)
        if let json = response.result.value {
            print("JSON: \(json)")
        }
    }
}
