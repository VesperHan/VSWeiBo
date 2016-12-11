//
//  Status.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/10.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

class Status: NSObject {

    var created_at : String?                // 微博创建时间
    var source : String?                    // 微博来源
    var text : String?                      // 微博的正文
    var mid : Int = 0                       // 微博的ID
    var user : User?
    
    init(dict:[String:AnyObject]) {
        
        super.init()
        
        setValuesForKeys(dict)
        
        if let userDict = dict["user"]{
            
            user = User(dict: userDict as! [String : AnyObject])
        }
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
}