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
        let composeBtn = UIButton(image: #imageLiteral(resourceName: "tabbar_compose_icon_add"),
                                  imageHigh: #imageLiteral(resourceName: "tabbar_compose_icon_add_highlighted"),
                                  bgImage: #imageLiteral(resourceName: "tabbar_compose_button"),
                                  bgImageHigh: #imageLiteral(resourceName: "tabbar_compose_button_highlighted"))
        
        tabBar.addSubview(composeBtn)
        composeBtn.center = CGPoint(x:tabBar.center.x,y:tabBar.bounds.size.height*0.5)
        
        //监听事件点击
        composeBtn.addTarget(self, action: #selector(composeClick(sender:)), for: .touchUpInside)
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
                item.isEnabled = false
                return
            }
            //设置item其他选中图片
            //item.selectedImage = UIImage.init(named: imageNames[i])
        }
    }
}

// MARK:- 事件监听
// 事件监听的本质是发送消息,但是发送消息是OC的特性
// 方法包装成@SEL-->类中查找方法列表--> 根据@SEL找到imp指针(函数指针)-->执行函数->如果方法是private,函数就不会在方法列表中
extension MainTabBarController {

    @objc fileprivate func composeClick(sender:UIButton){
        
        self.selectedIndex = 2
    }
}
