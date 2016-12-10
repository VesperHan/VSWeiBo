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
    
    //计算属性
    var defaultController:UIViewController{
    
        let isLogin = UserAccountViewModel.shareIntance.isLogin
        return isLogin ? WelcomeViewController() :UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = defaultController
        window?.makeKeyAndVisible()
        return true
    }
}

func Infolog<T>(_ message:T,file:String = #file,line:Int = #line) {
    
    let fileName =  (file as NSString).lastPathComponent
    print("\(currentTime())\(fileName)Line:\(line) ->Info \n\(message)")
}

func Errolog<T>(_ message:T,file:String = #file,line:Int = #line) {
    
    let fileName =  (file as NSString).lastPathComponent
    print("\(currentTime())\(fileName)Line:\(line) ->Erro \n\(message)")
}

func currentTime() -> String {
    
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    let dateStr = dateFormatter.string(from: date)
    
    return dateStr
}
