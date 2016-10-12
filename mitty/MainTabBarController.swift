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
        
        tab1 = UINavigationController(rootViewController: Tab1ViewController())
        tab2 = UINavigationController(rootViewController: Tab2ViewController())
        tab3 = UINavigationController(rootViewController: Tab3ViewController())
        tab4 = UINavigationController(rootViewController: Tab4ViewController())
        
        
        tab1.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.bookmarks, tag: 1)
        tab2.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.contacts, tag: 2)
        tab3.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.downloads, tag: 3)
        tab4.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.favorites, tag: 4)
        
        let tabs = NSArray(objects: tab1!, tab2!, tab3!, tab4!)
        
        self.setViewControllers(tabs as? [UIViewController], animated: false)
    }
}
