//
//  EmoticonPackage.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/16.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

class EmoticonPackage: NSObject {

    var emoticons:[Emoticon] = [Emoticon]()
    
    init(id:String) {
        super.init()
        
        if id == ""{

            return
        }
        
        let plistPath = Bundle.main.path(forResource: "\(id)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle")
        
        let array = NSArray(contentsOfFile: plistPath!) as! [[String:String]]
        
        var index = 0
        for var dict in array {
            if let png = dict["png"]{
                //拼接完整路径
                dict["png"] = id + "/" + png
            }
            emoticons.append(Emoticon(dict:dict))
            index += 1
        }
    }
}
