//
//  AppDelegate.swift
//  Puranas
//
//  Created by Lucky Clover on 5/23/17.
//  Copyright © 2017 Lucky Clover. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let font = UIFont(name: "Mallanna", size: 25) {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font]
        }
        
        return true
    }
    
    func configureUI() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navVC = storyboard.instantiateViewController(withIdentifier: "NavigationController")
        window?.rootViewController = navVC
    }

    func applicationWillResignActive(_ application: UIApplication) {
        mainVC?.saveLastReadingPos()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        mainVC?.saveLastReadingPos()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        mainVC?.saveLastReadingPos()
    }

}

