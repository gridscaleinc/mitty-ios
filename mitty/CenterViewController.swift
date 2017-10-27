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
import UICircularProgressRing

//
// 個人情報を管理するView
//
@objc(CenterViewController)
class CenterViewController: MittyViewController, CLLocationManagerDelegate {

    let myLocationManager = CLLocationManager()
    var socialMirror: SocialMirrorForm!
    let myMapView = MKMapView()
    let guide = GuidanceForm()
    let display = MQForm.newAutoLayout()
    var timer = Timer()
    
    var sliderBar: Control = {
        let rect1 = CGRect(x: 3, y: 3, width: 220, height: 150)
        let marquee = MarqueeLabel(frame: rect1)
        marquee.numberOfLines = 2
        
        marquee.type = .continuous
        marquee.speed = .duration(50)
        marquee.animationCurve = .linear
        marquee.fadeLength = 10.0
        marquee.leadingBuffer = 10.0
        
        marquee.font = UIFont.systemFont(ofSize: 16)
        
        return Control(name:"marquee", view:marquee)
        
    }()
    
    // Autolayout済みフラグ
    var didSetupConstraints = false

    let indicator: BaguaIndicator = {
        let rect = CGRect(x: 0, y: 0, width: 40, height: 40 / 1.414)
        let ind = BaguaIndicator(frame: rect)
        return ind
    }()

    let commandboard = ControlPanel(h:500)
    
    let sep = HL(MittyColor.gray, 1)
    
    let navigator = ControlPanel(h:120)
    
    let picture: Control = MQForm.button(name: "m2", title: "")

    var nearlyDestinations = [Destination]()
    
    var targetLocation: Destination? = nil

    let destinationForm = DestinationForm()
    
    var speedMeter: SpeedMeter? = nil

    var isStarting = true
    var currentLocationPin = MKPointAnnotation()

    let dashButton = MQForm.button(name: "opencommandboard", title: "D/B").layout {
        b in
        b.down(withInset: 2).holizontalCenter().height(50).width(50)
        b.button.setImage(UIImage(named:"uparrow"), for: .normal)
        b.button.setTitleColor(.white, for: .normal)
        b.button.layer.cornerRadius = 30
        b.button.layer.shadowColor = UIColor.gray.cgColor
        b.button.layer.shadowOffset = CGSize(width: 10, height: 10)
        b.button.layer.shadowRadius = 10
        b.button.layer.shadowOpacity = 0.4
    }
    
    let navigatorButton = MQForm.button(name: "opencommandboard", title: "D/B").layout {
        b in
        b.button.backgroundColor = UIColor.lightGray
        b.down(withInset: 70).holizontalCenter().height(60).width(60)
        b.button.setTitleColor(.white, for: .normal)
        b.button.layer.cornerRadius = 30
        b.button.layer.shadowColor = UIColor.gray.cgColor
        b.button.layer.shadowOffset = CGSize(width: 10, height: 10)
        b.button.layer.shadowRadius = 10
        b.button.layer.shadowOpacity = 0.4
    }
    
    let activityButton = MQForm.button(name: "activityButton", title: "活動")
    let islandButton = MQForm.button(name: "islandButton", title: "島会議")
    
    var haveAnyAdvice : (() -> Void)? = nil
    
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
        super.viewWillDisappear(true)
        self.navigationItem.title = "..."
        timer.invalidate()
    }

    //
    override func viewDidLoad() {
        super.viewDidLoad()


        super.autoCloseKeyboard()

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

        self.view.addSubview(picture.button)
        picture.button.setImage(UIImage(named: "pengin2")?.af_imageRoundedIntoCircle(), for: .normal)
        picture.layout {
            p in
            p.button.autoPinEdge(.left, to: .left, of: self.indicator)
            p.button.autoPinEdge(.top, to: .bottom, of: self.indicator, withOffset: 180)
            p.height(45).width(45)
            p.button.isHidden = true
            p.button.backgroundColor = .clear
        }

        picture.bindEvent(.touchUpInside) { _ in
            self.pictureTaped()
        }

        
        let strings = ["Loading .....................                            　"]

        sliderBar.label.text = strings[Int(arc4random_uniform(UInt32(strings.count)))]

        sliderBar.label.textColor = UIColor.red.withAlphaComponent(0.8)

        sliderBar.bindEvent(.touchUpInside) {
            b in
            
            self.showSocialMirror()
            
        }
        
        self.navigationItem.titleView = sliderBar.view

        LoadingProxy.set(self)


        loadForm()

        loadDestinations()

        socialMirror = SocialMirrorForm(self.navigationController!)
        loadSocialMirror()

        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.notDetermined {
            // まだ承認が得られていない場合は、認証ダイアログを表示
            myLocationManager.requestAlwaysAuthorization()
        }

        // 位置情報の更新を開始
        myLocationManager.startUpdatingLocation()
        
        self.commandboard.view.isHidden = true
        self.socialMirror.view.isHidden = true
        self.dashButton.view.isHidden = false
        
        super.lockView()
        didSetupConstraints = false
        
        self.view.setNeedsUpdateConstraints()
        

    }
    
    func showSocialMirror () {
        SocialContactService.instance.getSocailMirror(onComplete: {
            mirror in
            self.sliderBar.label.text = mirror.description
            self.socialMirror.load(mirror)
            
            let isHidden = self.socialMirror.view.isHidden
            self.socialMirror.view.isHidden = !isHidden
            self.view.bringSubview(toFront: self.socialMirror.view)
            
        }, onError: {
            error in
            self.sliderBar.label.text = "Error........"
        })
    }

    func pictureTaped() {
        let mySpan = MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
        let myRegion = MKCoordinateRegionMake(self.currentLocationPin.coordinate, mySpan)
        self.myMapView.region = myRegion
        picture.button.isHidden = true
    }

    func loadForm () {

        self.view.addSubview(dashButton.view)
        dashButton.bindEvent(.touchUpInside) {
            b in
            self.commandboard.view.isHidden = false
            self.dashButton.view.isHidden = !self.dashButton.view.isHidden
        }
        self.view.addSubview(sep.view)
        sep.layout {
            l in
            l.fillHolizon(40).putUnder(of: self.navigatorButton, withOffset: 6)
        }
        self.view.addSubview(navigatorButton.view)
        navigatorButton.bindEvent(.touchUpInside) {
            b in
            self.navigator.view.isHidden = !self.navigator.view.isHidden
            self.dashButton.view.isHidden = false
        }
        
        view.addSubview(display)

        display.backgroundColor = UIColor.white
        display.layer.shadowColor = UIColor.gray.cgColor
        display.layer.shadowOffset = CGSize(width: 5, height: 5)
        display.layer.shadowOpacity = 0.4
        
        display +++ destinationForm.layout {
            c in
            c.fillHolizon().upper()
//            c.view.layer.borderColor = UIColor.red.cgColor
//            c.view.layer.borderWidth = 1
        }
        display.isHidden = true
        
        destinationForm.build()

        destinationForm.onCheckin = {
            view in
            let checkinvc = CheckinViewController()
            if (self.targetLocation != nil) {
                checkinvc.footmark(self.targetLocation!)
            }
            self.navigationController?.pushViewController(checkinvc, animated: true)
        }

        view.addSubview(navigator.view)
        navigator.loadForm()
        navigator.layout {
            p in
            p.fillHolizon().verticalCenter()
        }
        navigator.view.isHidden = true
        
        let topRow = Row.Intervaled()
        
        topRow +++ MQForm.button(name: "search", title: "島たん").layout {
            b in
            b.height(40)
            b.button.setTitleColor(.white, for: .normal)
        }.bindEvent(.touchUpInside) {
            b in
            let vc = QuestViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            self.navigator.view.isHidden = true
        }
        
        topRow +++ activityButton.layout{
            b in
            b.height(40)
            b.button.setTitleColor(.white, for: .normal)
            }.bindEvent(.touchUpInside) {
            b in
            let ac = ActivityTopViewController()
            self.navigationController?.pushViewController(ac, animated: true)
            self.navigator.view.isHidden = true
        }
        
        topRow.spacing = 25
        
        topRow +++ islandButton.layout{
            b in
            b.height(40)
            b.button.setTitleColor(.white, for: .normal)
            }.bindEvent(.touchUpInside) {
            b in
            let ac = IslandViewController()
            self.navigationController?.pushViewController(ac, animated: true)
            self.navigator.view.isHidden = true
        }
        
        navigator <<< topRow.layout {
            top in
            top.fillHolizon().height(40).upMargin(40)
        }
        navigator <<< Row.LeftAligned().height(40)
        
        
        view.addSubview(commandboard.view)
        commandboard.loadForm()
        commandboard.layout {
            p in
            p.fillHolizon()
            p.view.autoPin(toBottomLayoutGuideOf: self, withInset: 0)
        }
        
        let row = Row.Intervaled()
        row.spacing = 25
        
        row +++ MQForm.button(name: "nearby", title: "S/Mirror").layout {
            c in
            c.height(40)
            c.button.setTitleColor(.white, for: .normal)
            }.bindEvent(.touchUpInside) {
                b in
                self.showSocialMirror()
        }
        
        row +++ MQForm.button(name: "destinations", title: "行先").layout {
            c in
            c.height(40)
            c.button.setTitleColor(.white, for: .normal)
            }.bindEvent(.touchUpInside) {
                b in
                self.loadDestinations()
        }
        
        row +++ MQForm.button(name: "dashboard", title: "D/Board").layout {
            c in
            c.height(40)
            c.button.setTitleColor(.white, for: .normal)
        }
        
        commandboard <<< row.layout() {
            r in
            r.fillHolizon().height(45).upMargin(40)
        }
        
        let row2 = Row.Intervaled()
        row2.spacing = 25
        
        row2 +++ MQForm.button(name: "Unopen", title: "📌㊙️").layout {
            c in
            c.height(40)
            c.button.setTitleColor(.white, for: .normal)
        }
        
        let settingsButton = MQForm.button(name: "settings", title: "⚙").layout {
            c in
            c.height(40)
            c.button.setTitleColor(.white, for: .normal)
        }
        row2 +++ settingsButton
        
        settingsButton.bindEvent(.touchUpInside) {
            b in
            let pinfoViewController = PersonalInfoViewController()
            self.navigationController?.pushViewController(pinfoViewController, animated: true)
        }
        
        row2 +++ MQForm.button(name: "signout", title: "Sign out").layout {
            b in
            b.button.setTitleColor(.white, for: .normal)
        }
        
        
        commandboard <<< row2.layout() {
            r in
            r.fillHolizon().height(45)
        }
        
        commandboard <<< Row.LeftAligned().height(40)
        
        commandboard.onClosed = {
            self.dashButton.view.isHidden = false
        }
        
    }

    func loadDestinations () {

        ActivityService.instance.getDestinationList() {
            destinations in
            let now = Date()
            self.nearlyDestinations = destinations
            
            self.myMapView.removeAnnotations(self.myMapView.annotations)
            
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
                self.display.isHidden = false
                self.destinationForm.setDestination(self.targetLocation!.islandName)
            } else {
                self.destinationForm.setDestination("-")
                self.haveAnyAdvice = {
                    self.showGuidances()
                }
            }
        }
    }

    func showGuidances() {
        guide.removeFromSuperview()
        self.view.addSubview(guide)
        guide.load()
        guide.autoPinEdge(.top, to: .bottom, of: display, withOffset: 30)
    }
    
    //
    // ビュー整列メソッド。PureLayoutの処理はここで存分に活躍。
    //
    override func updateViewConstraints() {

        super.updateViewConstraints()

        if (!didSetupConstraints) {
            picture.configLayout()

            display.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            display.autoPinEdge(.top, to: .top, of: indicator, withOffset: 0)
            display.autoSetDimension(.width, toSize: 180)
            display.autoPinEdge(.bottom, to: .bottom, of: destinationForm.view)

            display.layer.borderWidth = 0.7
            display.layer.borderColor = UIColor.white.cgColor
            dashButton.configLayout()
            navigatorButton.configLayout()
            
            display.configLayout()
            socialMirror.configLayout()
            commandboard.configLayout()
            navigator.configLayout()
            sep.configLayout()
            
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
    // この場所にイベントを作成することにしたいけど、どう実装する？
    func longPressed(sender: UILongPressGestureRecognizer) {

        //この処理を書くことにより、指を離したときだけ反応するようにする（何回も呼び出されないようになる。最後の話したタイミングで呼ばれる）
        if sender.state != UIGestureRecognizerState.began {
            return
        }

        //senderから長押しした地図上の座標を取得
        let tappedLocation = sender.location(in: myMapView)
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


            timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.updateSpeed
                ), userInfo: nil, repeats: true)

            timer.fire()

        } else {
            let visible = self.isViewLoaded && (self.view.window
                != nil)
            speedMeter?.updateLocation(nowLocation: myLocation)
            if let sm = speedMeter {
                if visible {
                    if sm.status == .moving {
                        //commandboard.updateAverageSpeed(sm.velocity)
                        //commandboard.updateInstantSpeed(sm.instantVelocity)
                    } else {
                        //commandboard.updateAverageSpeed(sm.velocity)
                        //commandboard.updateInstantSpeed(0)
                    }
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

    @objc
    func updateSpeed(tm: Timer) {
        if speedMeter == nil {
            return
        }

        if speedMeter?.status == .stopping {
            return
        }

        if Date().timeIntervalSince(speedMeter!.previousTime) > 10 {
            speedMeter!.status = .stopping
            //commandboard.updateInstantSpeed(0)
            //commandboard.updateAverageSpeed(0)
        }
    }

    func updateDistance(_ l: CLLocation) {
        if (targetLocation == nil) {
            return
        }
        let dest = CLLocation(latitude: targetLocation!.latitude, longitude: targetLocation!.longitude)
        let distanceMeter = dest.distance(from: l)
        destinationForm.setDistance(inMeter: distanceMeter)
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
    
    func loadSocialMirror() {
        self.view.addSubview(socialMirror.view)
        socialMirror.view.isHidden = true
        SocialContactService.instance.getSocailMirror(onComplete: {
            mirror in
            self.sliderBar.label.text = mirror.description
            self.socialMirror.load(mirror)
        }, onError: {
            error in
            self.sliderBar.label.text = error
        })
    }
}

extension CenterViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation === mapView.userLocation {
            return mapView.view(for: annotation)
        } else {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "UserLocation")
            annotationView.image = UIImage(named: "pengin1")?.af_imageRoundedIntoCircle()
            annotationView.layer.shadowColor = UIColor.gray.cgColor
            annotationView.layer.shadowOffset = CGSize(width: 10, height: 10)
            annotationView.layer.shadowOpacity = 0.4
            
            annotationView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            return annotationView
        }
    }
}
