//
//  MyselfViewController.swift
//
//  mitty
//
//  Created by Dongri Jin on 2016/10/12.
//  Copyright © 2016 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

//
// 個人情報を管理するView
//
@objc(MyselfViewController)
class MyselfViewController: UIViewController {
    
    // ラベル生成
    let label : UILabel = {
        let label = UILabel.newAutoLayout()
        label.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.2, alpha: 0.9)
        label.numberOfLines = 5
        label.lineBreakMode = .byClipping
        label.textColor = .white
        label.text = NSLocalizedString("この画面は個人情報を管理する画面です。個人情報とは、自分の名前、職業、住所などを幾つのグループに分けて管理します。¥n1) 名前など。¥n2)名刺. ¥n3) 保険証など。", comment: "何かがコメントがありましたら、どうぞ")
        
        return label
    }()

  
    
    // Autolayout済みフラグ
    var didSetupConstraints = false
    
    // ビューが表に戻ったらタイトルを設定。
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "個人情報を管理"
        
        // 1
        let nav = self.navigationController?.navigationBar
        // 2
        nav?.barStyle = UIBarStyle.blackTranslucent
        nav?.tintColor = UIColor.white
        // 3
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        // 4
        let image = UIImage(named: "myself")
        imageView.image = image
        // 5
        navigationItem.titleView = imageView
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    // ビューが非表示になる直前にタイトルを「...]に変える。
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = "..."
    }
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        // 色のビュルド仕方
        let swiftColor = UIColor(red: 0.3, green: 0.5, blue: 0.6, alpha: 0.9)
        self.view.backgroundColor = swiftColor

        // buttonを生成
        let button = UIButton()
        button.frame = CGRect(x: 150, y: 100, width: 100, height: 60)
        button.setTitle("登録する", for: .normal)
        // let image = UIImage(named: "button")
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.9)
        
        button.addTarget(self, action: #selector(MyselfViewController.editPersonalInfo), for: .touchUpInside)
        self.view.addSubview(button)
        self.view.addSubview(label)
        
        // ここでビューの整列をする。
        // 各サブビューのupdateViewConstraintsを再帰的に呼び出す。
        view.setNeedsUpdateConstraints()
        
    }
    
    //
    // ビュー整列メソッド。PureLayoutの処理はここで存分に活躍。
    //
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            
            label.autoPinEdge(toSuperviewEdge: .top, withInset: 180)
            label.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
            label.autoPinEdge(toSuperviewEdge: .trailing, withInset: 10)
            label.autoSetDimension(.height, toSize: 120.0)
            
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
