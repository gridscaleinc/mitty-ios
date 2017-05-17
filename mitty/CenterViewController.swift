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
class CenterViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate {
   
    //LocationManagerの生成（viewDidLoadの外に指定してあげることで、デリゲートメソッドの中でもmyLocationManagerを使用できる）
    let myLocationManager = CLLocationManager()
    
    let myMapView = MKMapView()
    
    let form = MQForm.newAutoLayout()
    let display = MQForm.newAutoLayout()

    
    // Autolayout済みフラグ
    var didSetupConstraints = false
    
    // ビューが表に戻ったらタイトルを設定。
    override func viewDidAppear(_ animated: Bool) {
  
        self.navigationItem.title = LS(key: "operation_center")
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    // ビューが非表示になる直前にタイトルを「...]に変える。
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

        //ここからが現在地取得の処理
        myLocationManager.delegate = self
        
        let rect = CGRect(x:0, y:0, width:40, height: 40/1.414)
        
        let indicator = BaguaIndicator(frame: rect)
        indicator.center = CGPoint(x: 30, y: 90)
        self.view.addSubview(indicator)
        indicator.startAnimating()
        
        let rect1 = CGRect(x:3, y:3, width:220, height: 150)
        let bagua = MarqueeLabel(frame: rect1)
        bagua.numberOfLines = 2
        
        bagua.type = .continuous
        bagua.speed = .duration(50)
        bagua.animationCurve = .linear
        bagua.fadeLength = 10.0
        bagua.leadingBuffer = 10.0
        
        bagua.font = UIFont.systemFont(ofSize: 16)
        
        let strings = ["May I talk to you?  MittyはSNSではない。SNSを築くツールです。Mittyのコセプトは人と人がバーチャルな空間ではなく、リアルな空間での出会いをサポートします。Mittyがあれば、人と人の新たな関係を良い形で容易に作れる。"]
        
        bagua.text = strings[Int(arc4random_uniform(UInt32(strings.count)))]
        
        bagua.textColor = swiftColor
        
        //self.view.addSubview(bagua)
        self.navigationItem.titleView = bagua
        
        let section = Section(name: "control-panel", view: UIView.newAutoLayout()).height(130).layout() {
            s in
            s.upper(withInset: 0).fillHolizon()
            s.view.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        }
        form +++ section
        
        var row = Row.Intervaled().layout() {
            r in
            r.fillHolizon().height(35)
        }
        row.spacing = 30
        
        row +++ MQForm.button(name: "Taxi", title: "🚕🚏").layout {
            c in
            c.height(35)
            c.button.backgroundColor = UIColor.orange.withAlphaComponent(0.7)
            c.button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        }
        row +++ MQForm.button(name: "PeopleNearby", title: "👨‍👩‍👧‍👦").layout {
            c in
            c.height(35)
            c.button.backgroundColor = UIColor.orange.withAlphaComponent(0.7)
            c.button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        }

        row +++ MQForm.button(name: "PeopleNearby", title: "島").layout {
            c in
            c.height(35)
            c.button.backgroundColor = UIColor.orange.withAlphaComponent(0.7)
            c.button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        }

        
        section <<< row
        
        row = Row.Intervaled().layout() {
            r in
            r.fillHolizon().height(40)
        }
        row.spacing = 30
        
        row +++ MQForm.button(name: "Transperent", title: "透明").layout {
            c in
            c.height(35)
            c.button.backgroundColor = UIColor.colorWithRGB(rgbValue: 0xF8F9F9, alpha: 0.5)
            c.button.setTitleColor(UIColor.black.lighterColor(percent: 0.7), for: .normal)
            c.button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        }

        row +++ MQForm.button(name: "Unopen", title: "📌㊙️").layout {
            c in
            c.height(35)
            c.button.backgroundColor = UIColor.colorWithRGB(rgbValue: 0xF8F9F9, alpha: 0.5)
            c.button.setTitleColor(UIColor.black.lighterColor(percent: 0.7), for: .normal)
            c.button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        }

        row +++ MQForm.button(name: "settings", title: "⚙").layout {
            c in
            c.height(35)
            c.button.backgroundColor = UIColor.colorWithRGB(rgbValue: 0xF8F9F9, alpha: 0.5)
            c.button.setTitleColor(UIColor.black.lighterColor(percent: 0.7), for: .normal)
            c.button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        }

        
        section <<< row
        
        form.configLayout()
        
        view.addSubview(form)
        
        
        view.addSubview(display)
        
        display.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        display.autoPinEdge(.top, to: .top, of: indicator, withOffset: 0)
        display.autoSetDimension(.height, toSize: 60)
        display.autoSetDimension(.width, toSize: 180)

        display.layer.borderWidth = 0.7
        display.layer.borderColor = UIColor.white.cgColor
        
        display +++ MQForm.label(name: "Taxi", title: "現在地:東京タワー🗼").layout {
            c in
            c.label.backgroundColor = UIColor(white:0.5, alpha:0.3)
            c.fillParent()
        }
        
        display.configLayout()

        
        // ここでビューの整列をする。
        // 各サブビューのupdateViewConstraintsを再帰的に呼び出す。
        view.setNeedsUpdateConstraints()
        
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.notDetermined {
            // まだ承認が得られていない場合は、認証ダイアログを表示
            myLocationManager.requestAlwaysAuthorization()
        }
        // 位置情報の更新を開始
        myLocationManager.startUpdatingLocation()
        
        
    }
    
    //
    // ビュー整列メソッド。PureLayoutの処理はここで存分に活躍。
    //
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            form.autoPin(toBottomLayoutGuideOf: self, withInset: 5)
            form.autoPinEdge(toSuperviewEdge: .left)
            form.autoPinEdge(toSuperviewEdge: .right)
            form.autoSetDimension(.height, toSize: 130)
            form.backgroundColor =  UIColor(white: 0.1, alpha: 0.0)
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }

    //
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 
    func editPersonalInfo() {
        let eidtorView = RegisterPersonalInfoViewController()
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
    
    var isStarting = true
    var currentLocationPin = MKPointAnnotation()
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
