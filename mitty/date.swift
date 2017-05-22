//
//  date.swift
//  mitty
//
//  Created by gridscale on 2017/04/29.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter
    }()
    
    static let monthDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    } ()
    
    static let dateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd' 'HH:mm"
        return formatter
    } ()
    
    static let longDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd' 'HH:mm"
        return formatter
    } ()
    
    static let time: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    } ()
}

extension Date {
    var iso8601UTC: String {
        return Formatter.iso8601.string(from: self)
    }
    
    var dateTime: String {
        return Formatter.dateTime.string(from: self)
    }
    
    var longDateTime: String {
        return Formatter.longDateTime.string(from: self)
    }
    
    var monthDay: String {
        return Formatter.monthDay.string(from: self)
    }
    
    var time: String {
        return Formatter.time.string(from: self)
    }

    
}

extension String {
    var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)   // "Mar 22, 2017, 10:22 AM"
    }
    
    var isISO8601 : Bool {
        let test = Formatter.iso8601.date(from: self)
        if (test != nil) {
            return true
        }
        return false
    }
}
