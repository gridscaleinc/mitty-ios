//
//  Strings.swift
//  mitty
//
//  Created by Dongri Jin on 2016/11/05.
//  Copyright © 2016 GridScale Inc. All rights reserved.
//

import Foundation

func LS(key : String!) -> String {
    let s:String? = Bundle.main.localizedString(forKey: key, value: "", table: nil)

    return s ?? ""
    
}
