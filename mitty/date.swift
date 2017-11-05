//
//  date.swift
//  mitty
//
//  Created by gridscale on 2017/04/29.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

// MARK: - フォマッタークラスを拡張。
extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter
    }()

    static let iso8601Long: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
        return formatter
    }()

    static let ymd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    } ()

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

    static let monthMedium: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL"
        return formatter
    }()

    static let time12: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()

    static let hour12: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h"
        return formatter
    }()
    static let minute0x: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        return formatter
    }()
    static let amPM: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "a"
        return formatter
    }()

}

extension Date {

    var iso8601UTC: String {
        return Formatter.iso8601.string(from: self)
    }

    var iso8601LongUTC: String {
        return Formatter.iso8601Long.string(from: self)
    }

    var dateTime: String {
        return Formatter.dateTime.string(from: self)
    }

    var longDateTime: String {
        return Formatter.longDateTime.string(from: self)
    }

    var ymd: String {
        if self == Date.nulldate {
            return ""
        }
        return Formatter.ymd.string(from: self)
    }

    var year9999: String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        return String(format: "%4d", year)
    }
    
    var month99: String {
        let calendar = Calendar.current
        let m = calendar.component(.month, from: self)
        return String(format: "%2d", m)
    }
    
    /// Return Month and year,
    /// ex. 2017.10
    var monthYear : String {
        return year9999 + "." + month99
    }

    var monthMedium: String {
        return Formatter.monthMedium.string(from: self)
    }
    
    var day99 : String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        return String(format: "%2d", day)
    }
    
    var hour12: String {
        return Formatter.hour12.string(from: self)
    }
    
    var minute0x: String {
        return Formatter.minute0x.string(from: self)
    }
    
    var amPM: String {
        return Formatter.amPM.string(from: self)
    }

    var monthDay: String {
        if self == Date.nulldate {
            return ""
        }
        return Formatter.monthDay.string(from: self)
    }

    var time: String {
        if self == Date.nulldate {
            return ""
        }
        return Formatter.time.string(from: self)
    }
    
    var time12: String {
        if self == Date.nulldate {
            return ""
        }
        return Formatter.time12.string(from: self)
    }
    
    static var nulldate: Date {
        let date = Date()
        let interval = date.timeIntervalSince1970
        return date.addingTimeInterval(-interval)
    }
}

extension String {
    fileprivate var dateFromISO8601: Date {
        return Formatter.iso8601.date(from: self) ?? Date.nulldate
    }

    var isISO8601: Bool {
        let test = Formatter.iso8601.date(from: self)
        if (test != nil) {
            return true
        }
        return false
    }

    fileprivate var dateFromISO8601Long: Date {
        return Formatter.iso8601Long.date(from: self) ?? .nulldate // "Mar 22, 2017, 10:22 AM"
    }

    var isISO8601Long: Bool {
        let test = Formatter.iso8601Long.date(from: self)
        if (test != nil) {
            return true
        }
        return false
    }

    func utc2Date() -> Date {
        if self.isISO8601 {
            return self.dateFromISO8601
        } else if self.isISO8601Long {
            return self.dateFromISO8601Long
        } else {
            return Date.nulldate
        }
    }
}
