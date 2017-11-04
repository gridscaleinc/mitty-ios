//
//  IdobataMeeting.swift
//  mitty
//
//  Created by gridscale on 2017/11/04.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

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
import Starscream
import CoreLocation
import UICircularProgressRing
import SwiftyJSON

class IdobataMeetingViewController : MittyViewController, WebSocketDelegate {
    
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
    
    var pingPongTimer : Timer? = nil
    
    var socket : WebSocket = {
        let ws = WebSocket(url: URL(string: "ws://dev.mitty.co/ws/abc")!, protocols: ["chat", "superchat"])
        ws.headers["X-Mitty-AccessToken"] = ApplicationContext.userSession.accessToken
        return ws
    } ()
    
    var status = MeetingStatus.initializing
    
    var disconnected = true
    
    var meeting : MeetingInfo!
    
    // MARK: - Properties
    var talkingList = [BubbleMessage]()
    
    let panel : UIView = UIView.newAutoLayout()
    var bottomCons : NSLayoutConstraint? = nil
    let talkInputField: StyledTextField
    let talkSendButton: UIButton
    
    let myMapView = MKMapView()
    
    var isStarting = true
    var currentLocationPin = MKPointAnnotation()
    var currentLocation = CLLocation(latitude: 0, longitude: 0)
    
    var userMap = [String : UserInfo]()
    
    // Autolayout済みフラグ
    var didSetupConstraints = false
    
    let indicator: BaguaIndicator = {
        let rect = CGRect(x: 0, y: 0, width: 40, height: 40 / 1.414)
        let ind = BaguaIndicator(frame: rect)
        return ind
    }()
    
    // MARK: - Initializers
    init(_ meeting: MeetingInfo) {
        
        self.meeting = meeting
        
        talkInputField = StyledTextField.newAutoLayout()
        talkInputField.placeholder = "input message here"
        talkInputField.layer.borderColor = MittyColor.sunshineRed.cgColor
        
        talkSendButton = UIButton.newAutoLayout()
        talkSendButton.setTitle("送信", for: .normal)
        talkSendButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        talkSendButton.backgroundColor = MittyColor.healthyGreen
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ビューが表に戻ったらタイトルを設定。
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = LS(key: "井戸端会議")
        // ここでビューの整列をする。
        // 各サブビューのupdateViewConstraintsを再帰的に呼び出す。
        view.setNeedsUpdateConstraints()
        ApplicationContext.locationManager.locationHander = onLocationUpdated(_:)
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
        myMapView.delegate = self
        myMapView.showsUserLocation = true
        myMapView.userTrackingMode = .followWithHeading
        
        indicator.center = CGPoint(x: 30, y: 90)
        self.view.addSubview(indicator)
        indicator.startAnimating()
        
        LoadingProxy.set(self)
        
        
        setupMeeting()
        
        super.lockView()
        didSetupConstraints = false
        self.view.setNeedsUpdateConstraints()
        
    }
    
    func setupMeeting () {
        talkInputField.layer.borderWidth = 1
        let leftPadding = UIView(frame: CGRect(x:0, y:0, width:15, height:40))
        talkInputField.leftView = leftPadding
        talkInputField.leftViewMode = UITextFieldViewMode.always
        
        addSubviews()
        addConstraints()
        
        talkSendButton.addTarget(self, action: #selector(sendMessage(_:)), for: .touchUpInside)
        socket.delegate = self
        
        
        manageKeyboard()
        
    }
    
    func loadMessages() {
        // TODO
        // 会話内容を表示
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
    func onLocationUpdated(_ location: CLLocation) {
        
        currentLocation = location
        //ピンの生成と配置
        currentLocationPin.coordinate = currentLocation.coordinate
        
        if isStarting {
            currentLocationPin.title = "現在地"
            
            self.myMapView.addAnnotation(currentLocationPin)
            //アプリ起動時の表示領域の設定
            //delta数字を大きくすると表示領域も広がる。数字を小さくするとより詳細な地図が得られる。
            let mySpan = MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
            let myRegion = MKCoordinateRegionMake(currentLocation.coordinate, mySpan)
            myMapView.region = myRegion
            isStarting = false
        }
    }
    
    
    func sendMessage(_ sender: UIButton) {
        if (talkInputField.text == "") {
            return
        }
        
        if (disconnected) {
            socket.connect()
            return
        }
        
        
        let message : [String:Any] = [
            "messageType" : "Conversation",
            "topic" : "Conversation:(\(meeting.id))",
            "command" : "teleport",
            "conversation" : [
                "meetingId" : NSNumber(value: meeting.id),
                "speaking" : talkInputField.text ?? "No message",
                "speakTime" : Date().iso8601UTC,
            ],
            "teleportation" : [
                "latitude" : currentLocation.coordinate.latitude,
                "longtidude" : currentLocation.coordinate.longitude,
            ],
            ]
        
        let js = JSON(message).rawString()
        socket.write(string: js!)
        talkInputField.text = ""
        print(js ?? "")
        
    }
    
    // MessageType string `json:"messageType"`
    // Topic string `json:"topic"`
    // Command string `json:"command"`
    func subscribe() {
        let message : [String:Any] = [
            "messageType" : "Conversation",
            "topic" : "Conversation:(\(meeting.id))",
            "command" : "subscribe"
        ]
        
        let js = JSON(message).rawString()
        
        socket.write(string: js!)
        
    }
    
    
    func camera() {
        
    }
    
    func search() {
        
    }
    
    private func addSubviews() {
        
        view.addSubview(panel)
        panel.backgroundColor = UIColor.white
        panel.addSubview(talkInputField)
        panel.addSubview(talkSendButton)
        
    }
    
    private func addConstraints() {
        
        panel.autoPin(toBottomLayoutGuideOf: self, withInset: 1)
        panel.autoPinEdge(toSuperviewEdge: .left, withInset: 2)
        panel.autoPinEdge(toSuperviewEdge: .right, withInset: 2)
        panel.autoSetDimension(.height, toSize: 40)
        
        talkInputField.autoPinEdge(toSuperviewEdge: .left)
        talkInputField.autoPinEdge(toSuperviewEdge: .top)
        talkInputField.autoPinEdge(toSuperviewEdge: .bottom)
        talkInputField.autoPinEdge(toSuperviewEdge: .right, withInset: 80)
        
        talkSendButton.autoPinEdge(.left, to: .right, of: talkInputField, withOffset:2)
        talkSendButton.autoPinEdge(toSuperviewEdge: .top)
        talkSendButton.autoPinEdge(toSuperviewEdge: .bottom)
        talkSendButton.autoPinEdge(toSuperviewEdge: .right)
        
    }
    
    @objc
    override func onKeyboardShow(_ notification: NSNotification) {
        
    }
    
    
    @objc
    override func onKeyboardHide(_ notification: NSNotification) {
        
        self.view.setNeedsUpdateConstraints()
    }
    
    // MARK: Websocket Delegate Methods.
    func websocketDidConnect(socket: WebSocket) {
        print("websocket is connected")
        subscribe()
        disconnected = false
        
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
            pingPongTimer?.invalidate()
        } else {
            print("websocket disconnected, auto reconnecting.")
            socket.connect()
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        let js = JSON.parse(text)
        print(text)
        print(js)
        
        let tk1 = Talk()
        
        if js["conversation"] != nil {
            let conversationJs = js["conversation"]
            tk1.meetingId = conversationJs["meetingId"].int64!
            tk1.speakerId = conversationJs["speakerId"].int64!
            tk1.speakTime = conversationJs["speakTime"].stringValue.utc2Date()
            tk1.speaking = conversationJs["speaking"].rawString()!
            
            let v = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 55))
            v.backgroundColor = MittyColor.white
            v.layer.borderColor = MittyColor.sunshineRed.cgColor
            v.layer.borderWidth = 1
            v.layer.cornerRadius = 10
            
            let msg = BubbleMessage(name:"", view:v)
            msg.msgLabel.label.text = tk1.speaking
            
            self.view.addSubview(msg.view)
            
            msg.release(vc: self, msg: tk1.speaking)
        }
        
        if !js["teleportation"].isEmpty {
            let teleportation = js["teleportation"]
            var teleport = CLLocationCoordinate2D()
            teleport.latitude = teleportation["latitude"].doubleValue
            teleport.longitude = teleportation["longitude"].doubleValue
        }
        
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        print("Received data: \(data.count)")
    }
    
}

extension IdobataMeetingViewController: MKMapViewDelegate {
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


