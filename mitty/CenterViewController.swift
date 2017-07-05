//
//  CenterViewController.swift
//
//  mitty
//
//  Created by Dongri Jin on 2016/10/12.
//  Copyright © 2016 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import MapKit

import CoreLocation

//
// 個人情報を管理するView
//
@objc(CenterViewController)
class CenterViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
   
    //LocationManagerの生成（viewDidLoadの外に指定してあげることで、デリゲートメソッドの中でもmyLocationManagerを使用できる）
    let myLocationManager = CLLocationManager()
    
    let myMapView = MKMapView()
    
    let form = MQForm.newAutoLayout()
    let display = MQForm.newAutoLayout()

    // Autolayout済みフラグ
    var didSetupConstraints = false
    
    let indicator : BaguaIndicator = {
        let rect = CGRect(x:0, y:0, width:40, height: 40/1.414)
        let ind = BaguaIndicator(frame: rect)
        return ind
    }()
    
    let speedDisplay = MQForm.label(name: "speed", title: "0.0 M/S")
    
    let picture : Control = MQForm.button(name: "m2", title: "")
    
    var targetLocation : Destination? = nil
    
    let targetLocationDisp = MQForm.label(name: "Taxi", title: " 現在地:東京タワー🗼")
    var speedMeter : SpeedMeter? = nil
    
    var isStarting = true
    var currentLocationPin = MKPointAnnotation()
    
    // ビューが表に戻ったらタイトルを設定。
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = LS(key: "operation_center")
        self.tabBarController?.tabBar.isHidden = false
        // ここでビューの整列をする。
        // 各サブビューのupdateViewConstraintsを再帰的に呼び出す。
        view.setNeedsUpdateConstraints()
    }
    
    // ビューが非表示になる直前にタイトルを「...」に変える。
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = "..."
    }
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = LS(key: "operation_center")
        
        // 色のビュルド仕方
        let swiftColor = UIColor(red: 0.3, green: 0.5, blue: 0.6, alpha: 1)
        self.view.backgroundColor = swiftColor
        
        myMapView.frame = self.view.frame
        self.view.addSubview(myMapView)
        
        //長押しを探知する機能を追加
        let longTapGesture = UILongPressGestureRecognizer()
        longTapGesture.addTarget(self, action: #selector(longPressed))
        myMapView.addGestureRecognizer(longTapGesture)
        myMapView.showsUserLocation = true
        myMapView.userTrackingMode = .followWithHeading

        //ここからが現在地取得の処理
        myLocationManager.delegate = self
        
        indicator.center = CGPoint(x: 30, y: 90)
        self.view.addSubview(indicator)
        indicator.startAnimating()
        
        
        speedDisplay.label.textColor = UIColor.red
        speedDisplay.label.font = speedDisplay.label.font.withSize(13)
        self.view.addSubview(speedDisplay.view)
        
        self.view.addSubview(picture.button)
        picture.button.setImage(UIImage(named: "pengin2")?.af_imageRoundedIntoCircle(), for: .normal)
        picture.layout {
            p in
            p.button.autoPinEdge(.left, to: .left, of: self.indicator)
            p.button.autoPinEdge(.top, to: .bottom, of: self.indicator, withOffset: 180)
            p.height(45).width(45)
            p.button.isHidden = true
            p.button.backgroundColor  = .clear
        }
        
        picture.bindEvent(.touchUpInside) { _ in
            self.pictureTaped()
        }
        
        let rect1 = CGRect(x:3, y:3, width:220, height: 150)
        let bagua = MarqueeLabel(frame: rect1)
        bagua.numberOfLines = 2
        
        bagua.type = .continuous
        bagua.speed = .duration(50)
        bagua.animationCurve = .linear
        bagua.fadeLength = 10.0
        bagua.leadingBuffer = 10.0
        
        bagua.font = UIFont.systemFont(ofSize: 16)
        
        let strings = ["招待：１件、　本日の予定：３件、                            　"]
        
        bagua.text = strings[Int(arc4random_uniform(UInt32(strings.count)))]
        
        bagua.textColor = swiftColor
        
        //self.view.addSubview(bagua)
        self.navigationItem.titleView = bagua
        
        LoadingProxy.set(self)

    
        loadForm()
        
        loadDestinations()
        

        
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.notDetermined {
            // まだ承認が得られていない場合は、認証ダイアログを表示
            myLocationManager.requestAlwaysAuthorization()
        }
        
        // 位置情報の更新を開始
        myLocationManager.startUpdatingLocation()

    }
    
    func pictureTaped() {
        let mySpan = MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
        let myRegion = MKCoordinateRegionMake(self.currentLocationPin.coordinate, mySpan)
        self.myMapView.region = myRegion
        picture.button.isHidden = true
    }
    
    func loadForm (){
        
        let section = Section(name: "control-panel", view: UIView.newAutoLayout()).height(150).layout() {
            s in
            s.upper(withInset: 0).fillHolizon()
            s.view.backgroundColor = UIColor(white: 0.15, alpha: 0.15)
        }
        
        form +++ section
        
        var row = Row.Intervaled().layout() {
            r in
            r.fillHolizon().height(45)
        }
        row.spacing = 60
        

        row +++ MQForm.button(name: "nearby", title: "Near By").layout {
            c in
            c.height(30)
            c.button.backgroundColor = UIColor.orange.withAlphaComponent(0.9)
            c.button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        }
        
        row +++ MQForm.button(name: "destinations", title: "行先").layout {
            c in
            c.height(30)
            c.button.backgroundColor = UIColor.orange.withAlphaComponent(0.9)
            c.button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            }.bindEvent(.touchUpInside) {
                b in
                self.loadDestinations()
        }
        
        section <<< row
        
        row = Row.Intervaled().layout() {
            r in
            r.fillHolizon().height(40)
        }
        
        row.spacing = 60
        

        row +++ MQForm.button(name: "Unopen", title: "📌㊙️").layout {
            c in
            c.height(30)
            c.button.backgroundColor = UIColor.colorWithRGB(rgbValue: 0xF8F9F9, alpha: 0.9)
            c.button.setTitleColor(UIColor.black.lighterColor(percent: 0.7), for: .normal)
            c.button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        }
        
        let settingsButton = MQForm.button(name: "settings", title: "⚙").layout {
            c in
            c.height(30)
            c.button.backgroundColor = UIColor.colorWithRGB(rgbValue: 0xF8F9F9, alpha: 0.9)
            c.button.setTitleColor(UIColor.black.lighterColor(percent: 0.7), for: .normal)
            c.button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        }
        row +++ settingsButton
        
        settingsButton.bindEvent(.touchUpInside) {
            b in
            let pinfoViewController = PersonalInfoViewController()
            self.navigationController?.pushViewController(pinfoViewController, animated: true)
        }
        section <<< row
        
        view.addSubview(form)
        
        view.addSubview(display)
        
        display +++ targetLocationDisp.layout {
            c in
            c.label.backgroundColor = UIColor.orange.withAlphaComponent(0.3)
            c.label.numberOfLines = 1
            c.label.adjustsFontSizeToFitWidth = true
            c.label.textColor = UIColor.gray.darkerColor(percent: 19)
            c.label.shadowColor = .white
            c.label.shadowOffset = CGSize(width: 0.1, height: 0.1)
            c.height(50).fillHolizon().upper()
        }
        
        let checkinButton = MQForm.button(name: "checkin", title: "").layout {
            b in
            b.button.setImage(UIImage(named:"checkin.jpeg")?.af_imageRoundedIntoCircle(), for: .normal)
            b.down(withInset: 5).height(40).width(40).leftMost(withInset:5)
            b.button.backgroundColor = UIColor.clear
            b.button.layer.borderWidth = 0
        }
        
        checkinButton.bindEvent(.touchUpInside) {
            view in
            let checkinvc = CheckinViewController()
            self.navigationController?.pushViewController(checkinvc, animated: true)
        }
        
        display +++ checkinButton
        
        
        display +++ MQForm.label(name: "checkLabel", title: "  チェックイン").layout {
            l in
            l.label.backgroundColor = UIColor.clear
            l.down(withInset: 5).height(40).width(130).rightMost(withInset: 5)
        }

    }
    
    func loadDestinations () {
        
        ActivityService.instance.getDestinationList() {
            destinations in
            let now = Date()
            
            for d in destinations {
                
                if (d.latitude == 0 && d.longitude == 0) {
                    continue
                }
                
                // すぎたイベントは非表示
                if d.eventTime < now {
                    continue
                }
                
                let point = CLLocationCoordinate2D (latitude: d.latitude, longitude: d.longitude)
                print(point)
                
                //ピンの生成
                let pin = MKPointAnnotation()
                //ピンを置く場所を指定
                pin.coordinate = point
                //ピンのタイトルを設定
                pin.title = d.islandName
                //ピンのサブタイトルの設定
                pin.subtitle = "\(d.eventTitle)"
                //ピンをMapViewの上に置く
                self.myMapView.addAnnotation(pin)
                self.myMapView.showAnnotations(self.myMapView.annotations, animated: true)
                
                if (self.targetLocation == nil) {
                    self.targetLocation = d
                } else {
                    if self.targetLocation!.eventTime > d.eventTime {
                        self.targetLocation = d
                    }
                }
            }
            
            if (self.targetLocation != nil) {
                self.targetLocationDisp.label.text = self.targetLocation?.islandName
            } else {
                self.targetLocationDisp.label.text = ""
            }
            
            
        }
    }
    
    //
    // ビュー整列メソッド。PureLayoutの処理はここで存分に活躍。
    //
    override func updateViewConstraints() {
        
        super.updateViewConstraints()
        
        if (!didSetupConstraints) {
            picture.configLayout()
            
            form.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5)
            form.autoPinEdge(toSuperviewEdge: .left)
            form.autoPinEdge(toSuperviewEdge: .right)
            form.autoSetDimension(.height, toSize: 130)
            form.backgroundColor =  UIColor(white: 0.9, alpha: 0.0)
            
            display.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            display.autoPinEdge(.top, to: .top, of: indicator, withOffset: 0)
            display.autoSetDimension(.height, toSize: 100)
            display.autoSetDimension(.width, toSize: 180)
            
            speedDisplay.label.autoPinEdge(.top, to: .bottom, of: indicator, withOffset: 10)
            speedDisplay.label.autoPinEdge(.left, to: .left, of: indicator)
            speedDisplay.height(30).width(300)
            
            display.layer.borderWidth = 0.7
            display.layer.borderColor = UIColor.white.cgColor
            
            form.configLayout()
            
            display.configLayout()

            didSetupConstraints = true
        }
        
    }

    //
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 
    func editPersonalInfo() {
        let eidtorView = PersonalInfoViewController()
        self.navigationItem.title = "..."
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(eidtorView, animated: true)
    }
    
    //長押しした時にピンを置く処理
    func longPressed(sender: UILongPressGestureRecognizer) {
        
        //この処理を書くことにより、指を離したときだけ反応するようにする（何回も呼び出されないようになる。最後の話したタイミングで呼ばれる）
        if sender.state != UIGestureRecognizerState.began {
            return
        }
        
        //senderから長押しした地図上の座標を取得
        let  tappedLocation = sender.location(in: myMapView)
        let tappedPoint = myMapView.convert(tappedLocation, toCoordinateFrom: myMapView)
        
        //ピンの生成
        let pin = MKPointAnnotation()
        //ピンを置く場所を指定
        pin.coordinate = tappedPoint
        //ピンのタイトルを設定
        pin.title = "中野区"
        //ピンのサブタイトルの設定
        pin.subtitle = "区役所付近"
        //ピンをMapViewの上に置く
        self.myMapView.addAnnotation(pin)
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
            speedMeter = SpeedMeter(start: myLocation)
            isStarting = false
        } else {
            speedMeter?.updateLocation(nowLocation: myLocation)
            if let sm = speedMeter {
                if sm.status == .moving {
                    speedDisplay.label.text = sm.velocityMeter
                } else {
                    speedDisplay.label.text = "停止中"
                }
            }
        }
        
        if myMapView.isUserLocationVisible {
            self.picture.button.isHidden = true
        } else {
            self.picture.button.isHidden = false
        }

        updateDistance(myLocation)
    }
    
    func updateDistance(_ l: CLLocation ) {
        if (targetLocation == nil) {
            return
        }
        let dest = CLLocation(latitude: targetLocation!.latitude, longitude: targetLocation!.longitude)
        let distance = String(format:"%.1f", dest.distance(from: l)/1000 )
        targetLocationDisp.label.text = targetLocation!.islandName + " \(distance) km"
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
