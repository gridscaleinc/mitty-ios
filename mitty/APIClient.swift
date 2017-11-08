//
//  APIClient.swift
//  mitty
//
//  Created by Dongri Jin on 2017/10/19.
//  Copyright © 2017 GridScale Inc. All rights reserved.
//

import Alamofire

private let host = "http://dev.mitty.co/api"

struct APIClient {
    let url: String
    let method: HTTPMethod
    let parameters: Parameters
    let headers: HTTPHeaders
    let encoding: ParameterEncoding

    init(path: String, method: HTTPMethod = .get, parameters: Parameters = [:], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders = [:]) {
        url = host + path
        self.method = method
        self.parameters = parameters
        self.encoding = encoding

        var headers = headers
        headers["X-Mitty-APIKEY"] = "pdXQWU2EpNMFPoCr6UAdMNUevAzuuG"
        self.headers = headers

    }
    
    func request(success: @escaping (_ data: Dictionary<String, Any>)-> Void, fail: @escaping (_ error: Error?)-> Void) {
        Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { response in
            if response.result.isSuccess {
                success(response.result.value as! Dictionary)
            }else{
                fail(response.result.error)
            }
        }
    }
}

