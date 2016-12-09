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
