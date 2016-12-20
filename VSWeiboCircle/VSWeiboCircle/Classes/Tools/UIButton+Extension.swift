//
//  UIButton+Extension.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/5.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

extension UIButton{

    //swift类方法是以class开头的方法就是oc中的 + 号方法
    class func buttonExtension(image:UIImage,bgImage:UIImage) -> UIButton {
        
        let btn = UIButton()
        
        btn.setBackgroundImage(#imageLiteral(resourceName: "tabbar_compose_button"), for: .normal)
        btn.setBackgroundImage(#imageLiteral(resourceName: "tabbar_compose_button_highlighted"), for: .highlighted)
        btn.setImage(#imageLiteral(resourceName: "tabbar_compose_icon_add"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "tabbar_compose_icon_add_highlighted"), for: .highlighted)
        btn.sizeToFit()
        
        return btn
    }
    
    //扩展构造函数, 不用上面的类方法,构造函数不需要返回值
    //convenience 遍历构造函数,通常用在对系统的类进行构造函数的扩充时会使用
    //特点:  - 遍历构造函数通常都是写在Extension里面
    //      - 遍历构造函数init前面需要加载convenience
    //      - 需要明确调用self.init()
    //推荐使用构造函数
    convenience init(image:UIImage,imageHigh:UIImage,bgImage:UIImage?,bgImageHigh:UIImage?) {
        
        self.init()
        
        setImage(image, for: .normal)
        setImage(imageHigh, for: .highlighted)
        setBackgroundImage(bgImage, for: .normal)
        setBackgroundImage(bgImageHigh, for: .highlighted)
        sizeToFit()
    }
    
    convenience init(bgColor : UIColor, fontSize : CGFloat, title : String) {
        self.init()
        
        setTitle(title, for: .normal)
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }
}
