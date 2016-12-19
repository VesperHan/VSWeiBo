//
//  UITextView+Extension.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/18.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import Foundation
import UIKit

class EmoticonAttachment: NSTextAttachment {
    
    var chs : String?
}

extension UITextView{

    /// 获取textView属性字符串,对应的表情字符串
    func getEmoticonString() -> String {
        // 1.获取属性字符串
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        
        // 2.遍历属性字符串
        let range = NSRange(location: 0, length: attrMStr.length)
        attrMStr.enumerateAttributes(in: range, options: []) { (dict, range, _) -> Void in
            if let attachment = dict["NSAttachment"] as? EmoticonAttachment {
                attrMStr.replaceCharacters(in: range, with: attachment.chs!)
            }
        }
        
        // 3.获取字符串
        return attrMStr.string
    }
    
     func insertEmoticonIntoTextView(emoticon:Emoticon){
        
        if emoticon.isEmpty {
            return
        }
        
        if emoticon.isRemove {
            
            self.deleteBackward()
            return
        }
        
        //如果是Emoji表情
        if emoticon.emojiCode != nil {
            
            //获取光标所在位置
            let textRange = self.selectedTextRange
            
            //替换Emoji表情
            self.replace(textRange!, withText: emoticon.emojiCode!)
            
            return
        }
        
        //图文混排
        //png图片加入并转换为属性字符串
        let attachment = NSTextAttachment()
        attachment.image = UIImage(contentsOfFile: emoticon.pngPath!)
        let font = self.font!
        attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        let attrImageStr = NSAttributedString(attachment: attachment)
        
        //创建可变属性字符串 把原来输入的字符串转换为属性字符串 作为拼接操作
        let arrrMStr = NSMutableAttributedString(attributedString: self.attributedText)
        
        // 4.3.将图片属性字符串,替换到可变属性字符串的某一个位置
        // 4.3.1.获取光标所在的位置
        let range = self.selectedRange
        arrrMStr.replaceCharacters(in: range, with: attrImageStr)
        
        //显示属性字符串
        self.attributedText = arrrMStr
        //属性字符串会出现文字变小的问题,所以font需要重置
        self.font = font
        
        //光标解决:文字中插入表情的时候,输入之后光标应该在+1的位置,而不是最后
        self.selectedRange = NSRange(location: range.location + 1, length: 0)
    }
}
