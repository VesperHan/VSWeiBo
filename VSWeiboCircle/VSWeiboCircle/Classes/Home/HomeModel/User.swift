//
//  User.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/11.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

class User: NSObject {

    //头像
    var profile_image_url : String?
    //昵称
    var screen_name : String?
    //认证类型
    var verified_type :Int = -1
    //会员等级
    var mbrank:Int = 0

    init(dict:[String:AnyObject]) {
        
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
