//
//  EmoticonManager.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/16.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

class EmoticonManager {

    var packages :[EmoticonPackage] = [EmoticonPackage]()
    
    init() {
        
        packages.append(EmoticonPackage(id: ""))
        packages.append(EmoticonPackage(id:"com.sina.default"))
        packages.append(EmoticonPackage(id:"com.apple.emoji"))
        packages.append(EmoticonPackage(id:"com.sina.lxh"))
    }
}
