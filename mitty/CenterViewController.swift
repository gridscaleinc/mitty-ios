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

        // buttonを生成
        let button = UIButton.newAutoLayout()
        button.frame = CGRect(x: 150, y: 100, width: 100, height: 55)
        button.setTitle("登録する", for: .normal)
        button.center = CGPoint(x: UIScreen.main.bounds.width/2, y: 95)
        
        let myMapView = MKMapView()
        myMapView.frame = self.view.frame
        self.view.addSubview(myMapView)
        
        // let image = UIImage(named: "button")
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.9)
        
        button.addTarget(self, action: #selector(CenterViewController.editPersonalInfo), for: .touchUpInside)
        self.view.addSubview(button)

        
        let rect = CGRect(x:100, y:100, width:UIScreen.main.bounds.width * 0.512, height: UIScreen.main.bounds.width * 0.512 / 1.414)
        
        let indicator = BaguaIndicator(frame: rect)
        indicator.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
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

        // ここでビューの整列をする。
        // 各サブビューのupdateViewConstraintsを再帰的に呼び出す。
        view.setNeedsUpdateConstraints()
        
    }
    
    //
    // ビュー整列メソッド。PureLayoutの処理はここで存分に活躍。
    //
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            
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
