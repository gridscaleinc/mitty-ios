//
//  UserManager.swift
//  mitty
//
//  Created by gridscale on 2017/10/24.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class UserPresence {
    var user: UserInfo!
    var landingDate: Date!
    var lastStayDate: Date!
    var annotation: MKPointAnnotation? = nil
    
    // 距離を計算
    func distanceFrom(location: CLLocation) -> Double {
        if annotation == nil {
            return Double(3.14*2*6400*1000)
        }
        
        let l = CLLocation(latitude: annotation!.coordinate.latitude, longitude: annotation!.coordinate.longitude)
        return l.distance(from: location)
    }
}

class UserManager {
    
    var timeout = 1000
    
    var userMap = [Int : UserPresence]()
    
    var me : UserPresence? = nil
    
    func user(_ user: UserInfo) {
        let userPresence = userMap[user.id]
        if (userPresence == nil) {
            let up = UserPresence()
            up.user = user
            up.landingDate = Date()
            up.lastStayDate = Date()
            userMap[user.id] = up
        } else {
            userPresence!.lastStayDate = Date()
        }
    }
    
    func usersInArea(center: CLLocation, radious: Double) -> [UserPresence] {
        var users = [UserPresence]()
        for userPresence in userMap.values {
            if userPresence.distanceFrom(location: center) > radious {
                continue
            }
            if Double(timeout) + userPresence.lastStayDate.timeIntervalSinceNow  < 0 {
               continue
            }
            users.append(userPresence)
        }
        return users
    }
    
    func timeoutedUsers() -> [UserPresence] {
        var users = [UserPresence]()
        for upserPresence in userMap.values {
            if Double(timeout) + upserPresence.lastStayDate.timeIntervalSinceNow  < 0 {
                users.append(upserPresence)
            }
        }
        return users
    }
    
    func presentUsers() -> [UserPresence] {
        var users = [UserPresence]()
        for upserPresence in userMap.values {
            if Double(timeout) + upserPresence.lastStayDate.timeIntervalSinceNow  > 0 {
                users.append(upserPresence)
            }
        }
        return users
    }
    
    /// user削除
    ///
    /// - Parameter users: 削除対象ユーザー
    func removeUsers(users: [UserInfo]) {
        for user in users {
            userMap.removeValue(forKey: user.id)
        }
    }
    
}
