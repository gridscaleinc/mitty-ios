//
//  MittyLocationManager.swift
//  mitty
//
//  Created by gridscale on 2017/10/28.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import CoreLocation

class MittyLocationManager : NSObject, CLLocationManagerDelegate {
    
    var locationStatus : CLAuthorizationStatus = .notDetermined
    var currentLocation : CLLocation! {
        didSet {
            locationHander?(currentLocation)
        }
    }

    var locationUpdated = false
    
    func start( by manager: CLLocationManager ) {
        manager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.notDetermined {
            manager.requestAlwaysAuthorization()
        }
        
        manager.startUpdatingLocation()
    }
    
    // GPSから値を取得した際に呼び出されるメソッド
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let myLocation = locations.last! as CLLocation
        
        currentLocation = myLocation
        locationUpdated = true
    }
    
    
    //GPSの取得に失敗したときの処理
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    //認証状態が変わったことをハンドリングする。
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        // 認証のステータスをログで表示.
        var statusStr = ""
        switch (status) {
        case .notDetermined:
            statusStr = "NotDetermined"
        case .restricted:
            statusStr = "Restricted"
        case .denied:
            statusStr = "Denied"
        case .authorizedAlways:
            statusStr = "AuthorizedAlways"
        case .authorizedWhenInUse:
            statusStr = "AuthorizedWhenInUse"
        }
        
        locationStatus = status
        
        print(" CLAuthorizationStatus: \(statusStr)")
        
    }
    
    var locationHander : ((_ location: CLLocation) -> Void)? = nil
}
