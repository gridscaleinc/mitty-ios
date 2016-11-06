//
//  MainTabBarController.swift
//  mitty
//
//  Created by Dongri Jin on 2016/10/12.
//  Copyright © 2016 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit


import PureLayout

/// メインタブコントローラ
/// 各タブのビューの生成を管理し、描画する。
/// イベントの処理？
@objc (MainTabBarController)
class MainTabBarController: UITabBarController {
    
    var tab1HomeController: UINavigationController!
    var tab2ActivityController: UINavigationController!
    var tab3IslandController: UINavigationController!
    var tab4SocialController: UINavigationController!
    var tab5MyselfController: UINavigationController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 各タブの生成
        //　ホームタブ
//        let layout = UICollectionViewLayout()
//        let showWinodowController = ShowWindowViewController(collectionViewLayout:layout)

        tab1HomeController = UINavigationController(rootViewController: HomeViewController ())
        tab1HomeController.tabBarItem = UITabBarItem(title: LS(key: "home"), image: UIImage(named: "home"), tag: 1)

        // 活動予定タブ
        tab2ActivityController = UINavigationController(rootViewController: ActivityViewController())
        tab2ActivityController.tabBarItem = UITabBarItem(title: LS(key: "activity"), image: UIImage(named: "activity"), tag: 2)
        
        // 島会議タブ
        tab3IslandController = UINavigationController(rootViewController: IslandViewController())
        tab3IslandController.tabBarItem = UITabBarItem(title: LS(key: "island"), image: UIImage(named: "island"), tag: 3)
        
        //　ソーシャルタブ
        tab4SocialController = UINavigationController(rootViewController:SocialViewController())
        tab4SocialController.tabBarItem = UITabBarItem(title: LS(key: "social"), image: UIImage(named:
            "social"), tag: 4)
    
        // 個人情報管理タブ
        tab5MyselfController = ViewControllerFactory.createPersonalInfoNaviController()
        
        // タブグループ登録
        let tabs = NSArray(objects: tab1HomeController, tab2ActivityController!, tab3IslandController!, tab4SocialController!, tab5MyselfController!)
        self.setViewControllers(tabs as? [UIViewController], animated: true)
        
        
    }
}
