//
//  WelcomeViewController.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/9.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var iconViewBotton: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let profileUrlString = UserAccountViewModel.shareIntance.userAccount?.avatar_large
        //?? 如果前面有值,可选类型解包赋值 ,如果可选类型没有值,直接使用??后面的值
        let url = URL(string: profileUrlString ?? "")
        iconView.setImageWith(url!, placeholderImage: #imageLiteral(resourceName: "avatar_default"))
        iconViewBotton.constant = UIScreen.main.bounds.height-200
        
        // 2.执行动画
        // Damping : 阻力系数,阻力系数越大,弹动的效果越不明显 0~1
        // initialSpringVelocity : 初始化速度
        // swift枚举,不想传值  就[] 要是用多个值 也用[]放里面
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options:[], animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
    }
}
