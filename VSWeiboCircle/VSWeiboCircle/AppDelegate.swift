//
//  AppDelegate.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/2.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //创建window

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainTabBarController()
        window?.makeKeyAndVisible()
        return true
    }
}

