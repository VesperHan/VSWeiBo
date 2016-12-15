//
//  ComposeTextView.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/14.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

class ComposeTextView: UITextView {

    lazy var placeHolderLb = UILabel()
    //xib加载  第一步  添加子控件  规范
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        setupUI()
    }
    //从xib加载 第二步  对子控件做初始化操作  都在这里做也行,就是规范
//    override func awakeFromNib() {
//        
//    }
}

extension ComposeTextView{

    fileprivate func setupUI(){
    
        addSubview(placeHolderLb)
        placeHolderLb.snp.makeConstraints { (make) in
            
            make.top.equalTo(8)
            make.left.equalTo(10)
        }
    
        placeHolderLb.textColor = UIColor.lightGray
        placeHolderLb.font = font
        placeHolderLb.text = "分享新鲜事"
        
        textContainerInset = UIEdgeInsetsMake(6, 7, 0, 7)
    }
}
