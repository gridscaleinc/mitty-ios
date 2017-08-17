//
//  Code.swift
//  mitty
//
//  Created by gridscale on 2017/08/17.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
typealias CodeValue = (name: String, values: [String: (lang: String, value: String)])

/// <#Description#>
class CodeDic {
    /// <#Description#>
    private var codeDictionary: [String: CodeValue] = [:]
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - name: <#name description#>
    ///   - lang: <#lang description#>
    subscript(_ name: String, _ lang: String?) -> String? {
        return codeDictionary[name]?.values[lang ?? "EN"]?.value
    }
}
