//
//  FindEmoticon.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/19.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

class FindEmoticon: NSObject {
    
    static let shareIntance: FindEmoticon = FindEmoticon()
    
    private lazy var manager :EmoticonManager = EmoticonManager()
    
    func findAttiString(statusText:String?,font:UIFont) -> NSMutableAttributedString? {
        
        guard let statusText = statusText else {
            
            return nil
        }
        
        let pattern = "\\[.*?\\]"
        
        guard let  regex = try? NSRegularExpression(pattern: pattern, options: []) else{
            return nil
        }
        
        let results = regex.matches(in: statusText, options: [], range: NSRange.init(location: 0, length: statusText.characters.count))
        
        let attrMStr = NSMutableAttributedString(string: statusText)
        
        var index = results.count - 1
        for _ in 0..<results.count {
            
            let result = results[index]
            
            index -= 1
            let chs = (statusText as NSString).substring(with: result.range)
            
            guard let pngPath = findPngPath(chs: chs) else {
                
                return nil
            }
            
            let attachment = NSTextAttachment()
            attachment.image = UIImage(contentsOfFile: pngPath)
            attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            let attImageStr = NSAttributedString(attachment: attachment)
            
            attrMStr.replaceCharacters(in: result.range, with: attImageStr)
        }
        return attrMStr
    }
    
    private func findPngPath(chs:String)-> String?{
    
    
        for package in manager.packages{
        
            for emoticon in package.emoticons {
                
                if emoticon.chs == chs {
                    return emoticon.pngPath
                }
            }
        }
        return nil
    }
}
