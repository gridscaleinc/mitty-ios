//
//  TeleportVIewController.swift
//  mitty
//
//  Created by gridscale on 2017/10/23.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import MapKit

import CoreLocation
import UICircularProgressRing

class TeleportViewController : MittyViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    //地図を表示
    //websocketを引き継ぐ
    
    //随時に位置情報を交換し、所在地を地図に更新。
    
    //
    //  CenterViewController.swift
    //
    //  mitty
    //
    //  Created by Dongri Jin on 2016/10/12.
    //  Copyright © 2016 GridScale Inc. All rights reserved.
    //
    

    
    //LocationManagerの生成（viewDidLoadの外に指定してあげることで、デリゲートメソッドの中でもmyLocationManagerを使用できる）
    let myLocationManager = CLLocationManager()
    let myMapView = MKMapView()
    
    
    var isStarting = true
    var currentLocationPin = MKPointAnnotation()
    
    var bagua: Control = {
        let rect1 = CGRect(x: 3, y: 3, width: 220, height: 150)
        let bagua = MarqueeLabel(frame: rect1)
        bagua.numberOfLines = 2
        
        bagua.type = .continuous
        bagua.speed = .duration(50)
        bagua.animationCurve = .linear
        bagua.fadeLength = 10.0
        bagua.leadingBuffer = 10.0
        
        bagua.font = UIFont.systemFont(ofSize: 16)
        
        return Control(name:"bagua", view:bagua)
        
    }()
    
    // Autolayout済みフラグ
    var didSetupConstraints = false
    
    let indicator: BaguaIndicator = {
        let rect = CGRect(x: 0, y: 0, width: 40, height: 40 / 1.414)
        let ind = BaguaIndicator(frame: rect)
        return ind
    }()
    
    
    // ビューが表に戻ったらタイトルを設定。
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = LS(key: "teleport")
        self.tabBarController?.tabBar.isHidden = false
        // ここでビューの整列をする。
        // 各サブビューのupdateViewConstraintsを再帰的に呼び出す。
        view.setNeedsUpdateConstraints()
    }
    
    // ビューが非表示になる直前にタイトルを「...」に変える。
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationItem.title = "..."
    }
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        super.autoCloseKeyboard()
        
        self.navigationItem.title = LS(key: "teleport")
        
        // 色のビュルド仕方
        let swiftColor = UIColor(red: 0.3, green: 0.5, blue: 0.6, alpha: 1)
        self.view.backgroundColor = swiftColor
        
        myMapView.frame = self.view.frame
        self.view.addSubview(myMapView)
        
        myMapView.showsUserLocation = true
        myMapView.userTrackingMode = .followWithHeading
        
        //ここからが現在地取得の処理
        myLocationManager.delegate = self
        
        indicator.center = CGPoint(x: 30, y: 90)
        self.view.addSubview(indicator)
        indicator.startAnimating()
        
        LoadingProxy.set(self)
        
        
        
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.notDetermined {
            // まだ承認が得られていない場合は、認証ダイアログを表示
            myLocationManager.requestAlwaysAuthorization()
        }
        
        // 位置情報の更新を開始
        myLocationManager.startUpdatingLocation()
        
        super.lockView()
        didSetupConstraints = false
        self.view.setNeedsUpdateConstraints()
        
    }
    
    
    //
    // ビュー整列メソッド。PureLayoutの処理はここで存分に活躍。
    //
    override func updateViewConstraints() {
        
        super.updateViewConstraints()
        
        if (!didSetupConstraints) {
            didSetupConstraints = true
        }
        
    }
    
    //
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // GPSから値を取得した際に呼び出されるメソッド
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 配列から現在座標を取得（配列locationsの中から最新のものを取得する）
        let myLocation = locations.last! as CLLocation
        //Pinに表示するためにはCLLocationCoordinate2Dに変換してあげる必要がある
        let currentLocation = myLocation.coordinate
        //ピンの生成と配置
        currentLocationPin.coordinate = currentLocation
        
        if isStarting {
            currentLocationPin.title = "現在地"
            self.myMapView.addAnnotation(currentLocationPin)
            //アプリ起動時の表示領域の設定
            //delta数字を大きくすると表示領域も広がる。数字を小さくするとより詳細な地図が得られる。
            let mySpan = MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
            let myRegion = MKCoordinateRegionMake(currentLocation, mySpan)
            myMapView.region = myRegion
            isStarting = false
        }
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
        print(" CLAuthorizationStatus: \(statusStr)")
        
    }
}

