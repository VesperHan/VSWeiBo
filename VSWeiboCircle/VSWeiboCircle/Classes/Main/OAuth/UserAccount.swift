//
//  UserAccount.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/8.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import Foundation

class UserAccount: NSObject,NSCoding{
    
    //授权的access token
    var access_token : String?
    var uid : String?
    //属性监听器
    var expires_in : TimeInterval = 0{

        didSet  {   expires_date = Date(timeIntervalSinceNow: expires_in) as NSDate?}
    }
    //过期日期
    var expires_date : NSDate?
    var screen_name :String?
    var avatar_large :String?{
        didSet{
            avatar_url = URL(string: avatar_large ?? "")
        }
    }
    var avatar_url :URL?
    
    init(dict:[String:AnyObject]) {
        
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override var description: String{
    
        return dictionaryWithValues(forKeys: ["access_token", "expires_date", "uid","avatar_large", "screen_name"]).description
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(screen_name, forKey: "screen_name")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(avatar_url, forKey: "avatar_url")
        
    }
    required init?(coder aDecoder: NSCoder) {
        
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        avatar_large = aDecoder.decodeObject(forKey:"avatar_large") as? String
        screen_name = aDecoder.decodeObject(forKey:"screen_name") as? String
        expires_date = aDecoder.decodeObject(forKey:"expires_date") as? NSDate
        avatar_url = aDecoder.decodeObject(forKey:"avatar_url") as? URL
    }
}
