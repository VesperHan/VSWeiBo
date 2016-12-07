//
//  VSPresentController.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/7.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

class VSPresentController: UIPresentationController {

    fileprivate lazy var coverView = UIView()
    override func containerViewWillLayoutSubviews() {
        
        super.containerViewWillLayoutSubviews()
        
        presentedView?.frame = CGRect(x: 100, y: 55, width: 180, height: 250)
        
        //添加蒙版
        setupCoverView()
    }
}

extension VSPresentController {

    fileprivate func setupCoverView(){
    
        containerView?.insertSubview(coverView, at: 0)
        
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.3)
        
        //要用! 因为当containview?的时候 返回值为nil了,不能把nil赋值给frame
        //就是frame不能为nil
        coverView.frame = containerView!.bounds
        
        //添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(coverViewClick))
        coverView.addGestureRecognizer(tap)
    }
}

// MARK:- 事件监听
extension VSPresentController {
    @objc fileprivate func coverViewClick() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
