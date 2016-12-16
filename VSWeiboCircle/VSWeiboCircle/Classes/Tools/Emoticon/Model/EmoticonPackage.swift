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
            addEmptyEmoticon(true)
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
            
            //每20个表情需要添加删除按钮
            if index == 20 {
            
                emoticons.append(Emoticon(isRemove: true))
                index = 0
            }
        }
        
        addEmptyEmoticon(false)
    }
    
    private func addEmptyEmoticon(_ isRecently:Bool){
    
        let count = emoticons.count % 21
        
        if count == 0 && !isRecently {
            return
        }
        
        //添加空白表情
        for _ in count..<20 {
            emoticons.append(Emoticon(isEmpty:true))
        }
        //最后一个添加删除
        emoticons.append(Emoticon(isRemove:true))
    }
}
