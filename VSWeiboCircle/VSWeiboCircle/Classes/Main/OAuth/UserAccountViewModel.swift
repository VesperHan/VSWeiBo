//
//  UserAccountTool.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/9.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

class UserAccountViewModel {
    
    static let shareIntance = UserAccountViewModel()
    
    var userAccount : UserAccount?
    //计算属性
    var accountPath:String{
    
        //读取路径
        let accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return (accountPath as NSString).appendingPathComponent("account.plist")
    }
    
    var isLogin :Bool{
        
        if userAccount == nil {
            
            return false
        }
        guard let expiresDate = userAccount?.expires_date else {
            
            return false
        }
        
        return expiresDate.compare(Date()) == ComparisonResult.orderedDescending
    }
    
    //重写init方法 创建对象即可读取init方法
    init() {
       //读取信息
       userAccount = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
    }
}
