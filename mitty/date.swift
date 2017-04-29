//
//  date.swift
//  mitty
//
//  Created by gridscale on 2017/04/29.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

extension Date {
    func iso8601UTC() -> String {
        let iso8601UTCFormatter = DateFormatter()
        iso8601UTCFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        iso8601UTCFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return iso8601UTCFormatter.string(from: self)
    }
}
