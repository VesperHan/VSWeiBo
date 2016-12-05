//
//  VisitorView.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/5.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

class VisitorView: UIView {

// MARK:- 提供快速创建的类方法
    class func visitorView()-> VisitorView{
        // as! VisitorView 确定有这个文件,可以强制解析
        
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)?.first! as! VisitorView
    }
}
