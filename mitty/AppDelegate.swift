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
    
    // Class for view Mitty
    //let guideViewController: TutorialViewController = TutorialViewController()
    let guideViewController: GuideViewController = GuideViewController()
    //Tab bar
    
    let mittyNavigator = MittyNavigatorViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        ApplicationContext.startUp()
        
//        for i in 8 ... 12 {
//           print (QuadTree.GEN_HASH_ID(35.673995834554, 139.782535167754, i))
//        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.tintColor = MittyColor.healthyGreen;
        if ApplicationContext.skipGuideView  {
            if ApplicationContext.userSession.isLogedIn {
                 self.window?.rootViewController = mittyNavigator
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

