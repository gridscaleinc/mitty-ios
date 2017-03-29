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

//
// 個人情報を管理するView
//
@objc(CenterViewController)
class CenterViewController: UIViewController {
   
    let form = MQForm.newAutoLayout()
    
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
        
        let myMapView = MKMapView()
        myMapView.frame = self.view.frame
        self.view.addSubview(myMapView)
        
        
        let rect = CGRect(x:0, y:0, width:40, height: 40/1.414)
        
        let indicator = BaguaIndicator(frame: rect)
        indicator.center = CGPoint(x: 50, y: 120)
        self.view.addSubview(indicator)
        indicator.startAnimating()
        
        let rect1 = CGRect(x:20, y:10, width:280, height: 150)
        let bagua = MarqueeLabel(frame: rect1)
        bagua.numberOfLines = 2
        
        bagua.type = .continuous
        bagua.speed = .duration(50)
        bagua.animationCurve = .linear
        bagua.fadeLength = 10.0
        bagua.leadingBuffer = 10.0
        
        bagua.font = UIFont.systemFont(ofSize: 20)
        
        let strings = ["May I talk to you?  MittyはSNSではない。SNSを築くツールです。Mittyのコセプトは人と人がバーチャルな空間ではなく、リアルな空間での出会いをサポートします。Mittyがあれば、人と人の新たな関係を良い形で容易に作れる。"]
        
        bagua.text = strings[Int(arc4random_uniform(UInt32(strings.count)))]
        
        bagua.textColor = UIColor.red
        
        self.view.addSubview(bagua)

        
        let section = Section(name: "control-panel", view: UIView.newAutoLayout()).height(190).layout() {
            s in
            s.upper(withInset: 10).fillHolizon()
            s.view.backgroundColor = swiftColor
        }
        form +++ section
        
        var row = Row.Intervaled().layout() {
            r in
            r.fillHolizon().height(35)
        }
        
        row +++ form.button(name: "Taxi", title: "タクシー乗場").height(35)
        row +++ form.button(name: "PeopleNearby", title: "近くの人").height(35)
        row +++ form.button(name: "PeopleNearby", title: "近くの島").height(35)
        
        section <<< row
        
        row = Row.Intervaled().layout() {
            r in
            r.fillHolizon().height(40)
        }

        row +++ form.label(name: "Taxi", title: "現在地:東京タワー🗼").height(35)
        row +++ form.button(name: "checkIn", title: "チェックイン").height(35)
        
        section <<< row
        
        row = Row.Intervaled().layout() {
            r in
            r.fillHolizon().height(40)
        }

        row +++ form.button(name: "Transperent", title: "透明").height(35)
        row +++ form.button(name: "Unopen", title: "📌非公開").height(35)
        row +++ form.button(name: "settings", title: "＋設定").height(35)
        
        section <<< row
        
        form.configLayout()
        
        view.addSubview(form)
        
        // ここでビューの整列をする。
        // 各サブビューのupdateViewConstraintsを再帰的に呼び出す。
        view.setNeedsUpdateConstraints()
        
    }
    
    //
    // ビュー整列メソッド。PureLayoutの処理はここで存分に活躍。
    //
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            let swiftColor = UIColor(red: 0.3, green: 0.5, blue: 0.6, alpha: 1)
            form.autoPinEdge(toSuperviewEdge: .bottom)
            form.autoPinEdge(toSuperviewEdge: .left)
            form.autoPinEdge(toSuperviewEdge: .right)
            form.autoSetDimension(.height, toSize: 190)
            form.backgroundColor = swiftColor
            
            
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
}
