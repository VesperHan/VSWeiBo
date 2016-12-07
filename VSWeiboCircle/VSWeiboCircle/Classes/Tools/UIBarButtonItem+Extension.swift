//
//  UIBarButtonItem+Extension.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/6.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem{

    //便利构造函数 调用init
    convenience init(image:UIImage?,imageHight:UIImage?) {
        self.init()
        
        let btn = UIButton()
        btn.setImage(image, for: .normal)
        btn.setImage(imageHight, for: .highlighted)
        btn.sizeToFit()
        
        self.customView = btn
    }
    
    convenience init(fontImage:UIImage?,imageHight:UIImage?) {
        
        let btn = UIButton()
        btn.setImage(fontImage, for: .normal)
        btn.setImage(imageHight, for: .highlighted)
        btn.sizeToFit()
        
        //不一定是默认的init,也可以调用init customView
        self.init(customView:btn)
    }
}
