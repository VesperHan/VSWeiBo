//
//  MainTabBarController.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/2.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    // MARK:- 系统回调函数
    private lazy var imageNames = ["a","b","","c","d"]

    override func viewDidLoad() {
        super.viewDidLoad()

       tabBar.tintColor! = UIColor.orange
    }
    
    //在didload里的调整在view will appear里面会重新调整过来 所以要写在appear 里面
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //使用storybaor时时候 卸载didload会重新调整过来,所以要鞋子啊appear里面
        //手动设置选中tabbar的图片
        //因为选中图片也可以storyboard里面进行设置,所以无需用代码重写
        for i in 0..<tabBar.items!.count {
            
            //获取item
            let item = tabBar.items![i]
            
            //如果下标为2 item不可交互
            if i == 2 {
                
                item.isEnabled = false
                return
            }
            //设置item其他选中图片
//            item.selectedImage = UIImage.init(named: imageNames[i])
        }
    }
}
