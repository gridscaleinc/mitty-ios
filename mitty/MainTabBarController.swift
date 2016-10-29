//
//  MainTabBarController.swift
//  mitty
//
//  Created by Dongri Jin on 2016/10/12.
//  Copyright © 2016 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    var tab1: UINavigationController!
    var tab2: UINavigationController!
    var tab3: UINavigationController!
    var tab4: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tab1 = UINavigationController(rootViewController: ActivityViewController())
        tab2 = UINavigationController(rootViewController: IslandViewController())
        tab3 = UINavigationController(rootViewController: SocialViewController())
        tab4 = UINavigationController(rootViewController: MyselfViewController())
        
        tab1.tabBarItem = UITabBarItem(title: "Activity", image: UIImage(named: "activity"), tag: 1)
        
        tab2.tabBarItem = UITabBarItem(title: "Island", image: UIImage(named: "island"), tag: 2)
        tab3.tabBarItem = UITabBarItem(title: "Social", image: UIImage(named: "social"), tag: 3)
        tab4.tabBarItem = UITabBarItem(title: "Myself", image: UIImage(named: "myself"), tag: 4)
        
        let tabs = NSArray(objects: tab1!, tab2!, tab3!, tab4!)
        
        self.setViewControllers(tabs as? [UIViewController], animated: false)
    }
}
