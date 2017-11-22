//
//  MittyLocationManager.swift
//  mitty
//
//  Created by gridscale on 2017/10/28.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit


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
        locationStatus = CLLocationManager.authorizationStatus()
        if locationStatus == CLAuthorizationStatus.notDetermined {
            manager.requestAlwaysAuthorization()
        } else if locationStatus == CLAuthorizationStatus.denied {
            print("Location Service Not valid")
        } else {
            manager.startUpdatingLocation()
        }
    }
    
    func requestForLocationService (viewController: UIViewController, callback: @escaping ((Bool) -> Void)) {
        
        let dialogMessage = UIAlertController(title: "Confirm", message: "Mitty Need Location Info", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            self.openSettings(callback)
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        viewController.present(dialogMessage, animated: true, completion: nil)
    }
    
    func openSettings(_ callback: @escaping ((Bool) -> Void)) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, completionHandler : callback)
        } else {
            let opened = UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
            callback(opened)
        }
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
