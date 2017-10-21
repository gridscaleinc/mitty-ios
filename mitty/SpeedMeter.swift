//
//  SpeedMeter.swift
//  mitty
//
//  Created by gridscale on 2017/06/26.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import CoreLocation

class SpeedMeter {

    enum State {
        case start
        case moving
        case stopping
    }

    var previousLocation: CLLocation


    var previousTime: Date

    var status = State.start

    var acculatedDistance = 0.0
    var startTime: Date

    var velocity = 0.0
    var instantVelocity = 0.0
    var altitude = 0.0

    init(start: CLLocation) {
        previousLocation = start
        previousTime = start.timestamp
        startTime = start.timestamp
    }

    func updateLocation(nowLocation: CLLocation) {
        let nowtime = nowLocation.timestamp
        let displace = nowLocation.distance(from: previousLocation)
        let interval = nowtime.timeIntervalSince(previousTime)
        acculatedDistance += displace

        let acculatedTime = nowtime.timeIntervalSince(startTime)

        velocity = acculatedDistance / acculatedTime
        instantVelocity = displace / interval

        // if displace more than 3 meters, take it as moving
        if instantVelocity > 0.3 {
            status = .moving
        } else {
            instantVelocity = 0
            status = .stopping
            acculatedDistance = 0
            startTime = nowtime
        }
        altitude = nowLocation.altitude
        previousTime = nowtime
        previousLocation = nowLocation

    }

    var velocityMeter: String {
        if status != .moving {
            return "0.0 M/S"
        }

        return v(instantVelocity)
    }

    var averageVelocity: String {
        if status != .moving {
            return "0.0 M/S"
        }

        return v(velocity)

    }
    
    var kmh : Double {
        return velocity * 3.6
    }
    
    func v(_ velocity: Double) -> String {
        // Kilometers per Hour
        let kh = velocity / 1000 * 3600
        return String(format: "%.2f", kh) + " km/h"
    }

    var altitudeMeter: String {
        return "高度：" + String(format: "%.1f", altitude) + " m"
    }
}
