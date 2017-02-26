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
    var tab3MyselfController: UINavigationController!
    var tab4IslandController: UINavigationController!
    var tab5SocialController: UINavigationController!
    var freshLaunch = true
    
    override func viewWillAppear(_ animated: Bool) {
 

    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 各タブの生成
        //　ホームタブ
        tab1HomeController = UINavigationController(rootViewController: ExplorerTopViewController ())
        tab1HomeController.tabBarItem = UITabBarItem(title: LS(key: "explorer"), image: UIImage(named: "explorer"), tag: 1)

        // 活動予定タブ
        tab2ActivityController = UINavigationController(rootViewController: ActivityTopViewController())
        tab2ActivityController.tabBarItem = UITabBarItem(title: LS(key: "activity"), image: UIImage(named: "activity"), tag: 2)

        // 個人情報管理タブ
        tab3MyselfController = ViewControllerFactory.createPersonalInfoNaviController()
        
        // 島会議タブ
        tab4IslandController = UINavigationController(rootViewController: IslandViewController())
        tab4IslandController.tabBarItem = UITabBarItem(title: LS(key: "island"), image: UIImage(named: "island"), tag: 3)
        
        //　ソーシャルタブ
        tab5SocialController = UINavigationController(rootViewController:SocialViewController())
        tab5SocialController.tabBarItem = UITabBarItem(title: LS(key: "we"), image: UIImage(named:
            "we"), tag: 4)
    
        
        // タブグループ登録
        let tabs = NSArray(objects: tab1HomeController, tab2ActivityController!, tab3MyselfController, tab4IslandController!, tab5SocialController!)
        self.setViewControllers(tabs as? [UIViewController], animated: true)
        self.selectedIndex = 2
        
    }
}
