//
//  AppDelegate.swift
//  mitty
//
//  Created by Dongri Jin on 2016/10/12.
//  Copyright © 2016 GridScale Inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var skipGuideView = false;

    // Class for view Mitty
    //let guideViewController: TutorialViewController = TutorialViewController()
    let guideViewController: GuideViewController = GuideViewController()
    //Tab bar
    
    let mainTabBarController: MainTabBarController = MainTabBarController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        startUp()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let themeColor = UIColor(red: 0.1, green: 0.21, blue: 0.50, alpha: 1.0)
        self.window?.tintColor = themeColor;
        if skipGuideView == true {
            if ApplicationContext.isLogedIn {
                 self.window?.rootViewController = mainTabBarController
            } else {
                let signinViewController = SigninViewController()
                self.window?.rootViewController = signinViewController
            }
        } else {
            self.window?.rootViewController = guideViewController
        }
        self.window?.makeKeyAndVisible()

        return true
    }

    func startUp() {
        
        // 設定値の保存 キーは"keyName"、値は"value"としました。
        let config = UserDefaults.standard

        // 設定値の取得
        var accessCount : Int? = config.object(forKey: "access-count") as? Int
        
        print("Welcome to use \(String(describing: accessCount))")

        if (accessCount != nil) {
            skipGuideView = true
            ApplicationContext.isFirstTime = false
            accessCount = accessCount! + 1
            skipGuideView = true
        } else {
            accessCount = 1
        }
        
        config.set(accessCount, forKey:"access-count")
        config.synchronize() // シンクロを入れないとうまく動作しないときがあります
        
        // 存在しないキーはnilが返る
        let accessToken : String? = config.object(forKey: "ACCES-TOKEN") as? String
        
        if (accessToken != nil) {
            ApplicationContext.accessToken = accessToken!
            ApplicationContext.isLogedIn = true
        }
        
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

