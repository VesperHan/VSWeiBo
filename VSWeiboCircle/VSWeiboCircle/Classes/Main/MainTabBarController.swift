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
   fileprivate lazy var imageNames = ["a","b","","c","d"]
   fileprivate lazy var composeBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       tabBar.tintColor! = UIColor.orange
        
        setUpComposeBtn()

    }
    
    //在didload里的调整在view will appear里面会重新调整过来 所以要写在appear 里面
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setUpTabbarBtn()
    }
}

extension MainTabBarController {
    
    fileprivate func setUpComposeBtn(){
        
        //添加到tabbar中
        tabBar.addSubview(composeBtn)
        composeBtn.setBackgroundImage(#imageLiteral(resourceName: "tabbar_compose_button"), for: .normal)
        composeBtn.setBackgroundImage(#imageLiteral(resourceName: "tabbar_compose_button_highlighted"), for: .highlighted)
        composeBtn.setImage(#imageLiteral(resourceName: "tabbar_compose_icon_add"), for: .normal)
        composeBtn.setImage(#imageLiteral(resourceName: "tabbar_compose_icon_add_highlighted"), for: .highlighted)
        
        composeBtn.sizeToFit()
        
        composeBtn.center = CGPoint(x:tabBar.center.x,y:tabBar.bounds.size.height*0.5)
        composeBtn.addTarget(self, action: #selector(composeClick(sender:)), for: .touchUpInside)
    }
    
    @objc private func composeClick(sender:UIButton){
    
        self.selectedIndex = 2
    }
    
    fileprivate func setUpTabbarBtn(){
    
        //使用storybaor时时候 卸载didload会重新调整过来,所以要鞋子啊appear里面
        //手动设置选中tabbar的图片
        //因为选中图片也可以storyboard里面进行设置,所以无需用代码重写
        for i in 0..<tabBar.items!.count {
            
            //获取item
            let item = tabBar.items![i]
            
            //如果下标为2 item不可交互
            if i == 2 {
                
                item.isEnabled = true
                return
            }
            //设置item其他选中图片
            //item.selectedImage = UIImage.init(named: imageNames[i])
        }
    }
}
