
//
//  Emoticon.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/16.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

class Emoticon: NSObject {

    var code:String?{
    
        didSet{
            //目的:若不进行处理,则无法直接显示表情
            guard let code = code else {
                return
            }
            //创建扫描器
            let scanner = Scanner(string: code)
            //扫描出code的值
            var value:UInt32 = 0
            scanner.scanHexInt32(&value)
            //value转成字符
            let c = Character(UnicodeScalar(value)!)
            //转成字符串
            emojiCode = String(c)
        }
    }
    var png :String?{

        didSet{
        
            guard let png = png else{
                return
            }
            pngPath = Bundle.main.bundlePath + "/Emoticons.bundle/" + png
        }
    }
    var chs :String?
 
    var pngPath:String?
    var emojiCode:String?
    
    init(dict:[String:String]) {
    
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
    override var description: String{
    
        return dictionaryWithValues(forKeys: ["emojiCode","pngPath","chs"]).description
    }
}
