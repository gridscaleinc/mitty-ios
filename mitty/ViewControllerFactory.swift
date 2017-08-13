//
//  ViewControllerFactory.swift
//  mitty
//
//  Created by gridscale on 2016/10/30.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//

import Foundation

import PureLayout

///
/// Controllerを生成するクラス
/// <#Description#>
class ViewControllerFactory {

    // 個人情報管理ViewController作成。
    static func createPersonalInfoNaviController() -> UINavigationController {
        let naviController = UINavigationController(rootViewController: createSelfViewController())

        naviController.tabBarItem = UITabBarItem(title: LS(key: "center"), image: UIImage(named: "myself"), tag: 5)

        return naviController

    }

    ///
    ///
    static func createSelfViewController() -> CenterViewController {

        let vc = CenterViewController()
        return vc

    }

}
