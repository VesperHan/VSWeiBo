//
//  ComposeTitleView.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/14.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTitleView: UIView {

    fileprivate lazy var titleLabel = UILabel()
    fileprivate lazy var screenNameLb = UILabel()
    //构造函数
    override init(frame:CGRect){
    
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ComposeTitleView{

    fileprivate func setupUI(){
    
        addSubview(titleLabel)
        addSubview(screenNameLb)
        
        titleLabel.snp.makeConstraints { (make) in
            
            make.centerX.top.equalTo(self)
        }
        
        screenNameLb.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
        }
        
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        screenNameLb.font = UIFont.systemFont(ofSize: 14)
        screenNameLb.textColor = UIColor.lightGray
        
        titleLabel.text = "发微博"
        screenNameLb.text = UserAccountViewModel.shareIntance.userAccount?.screen_name
    }
}
