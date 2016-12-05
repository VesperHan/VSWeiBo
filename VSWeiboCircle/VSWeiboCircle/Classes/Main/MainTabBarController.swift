//
//  MainTabBarController.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/2.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //case 1
        traditionLoadController()
        
        //case 2
//        stringLoadController()
        
        //case 3
//        jsonLoadControllerMethod()
    }
    // MARK:- 方法一 传统创建tabbar
    private func traditionLoadController() -> Void {
    
        addChildViewController(HomeViewController(), title: "Home", iconName: "tabbar_home")
        addChildViewController(MessageViewController(), title: "Message", iconName: "tabbar_message_center")
        addChildViewController(DiscoverViewController(), title: "Discover", iconName: "tabbar_discover")
        addChildViewController(ProfileViewController(), title: "Profile", iconName: "tabbar_profile")
    }
    //swift支持方法重载
    //方法重载:方法名相同,但是参数不同 ->1.参数类型不同 2.参数个数不同
    //private私有化方法
    private func addChildViewController(_ childVC:UIViewController,title:String,iconName:String) -> Void {
        
        tabBar.tintColor = UIColor.orange
        childVC.title = title
        childVC.view.backgroundColor = UIColor.orange
        childVC.tabBarItem.image = UIImage(named: iconName)
        childVC.tabBarItem.selectedImage = UIImage(named:iconName+"_highlighted")
        let childNav = UINavigationController(rootViewController:childVC)
        addChildViewController(childNav)
    }
    
    // MARK:- 方法二 通过字符串创建对象
    private func stringLoadController() {
        // 需要指定是哪个文件下的类,防止类名相同找不到指定文件的问题,需要添加工程名字,目录要准确
        // print(HomeViewController())  //<VSWeiboCircle.HomeViewController: 0x7ffa8fd08960> 打印结果
        addChildViewController("HomeViewController", title: "Home", iconName: "tabbar_home")
        addChildViewController("MessageViewController", title: "Message", iconName: "tabbar_message_center")
        addChildViewController("DiscoverViewController", title: "Discover", iconName: "tabbar_discover")
        addChildViewController("ProfileViewController", title: "Profile", iconName: "tabbar_profile")
    }

    // MARK:- 方法三 通过json创建控制器
    private func jsonLoadControllerMethod(){

        guard let jsonPath = Bundle.main.path(forResource:"MainVCSettings.json",ofType: nil)else{
            print("cannot read path")
            return
        }
        // 读取json文件中的内容
        guard let jsonData = NSData.init(contentsOfFile: jsonPath) else{
            
            return
        }
        
        //data转成数组,如有调用某个方法是,该方法后面有一个throws,说明该方法会出现异常,如果抛出异常,就要进行处理
        //swift提供撒种处理异常的方式
        
        //1- try 程序员手动捕捉并处理异常
        do {
            try JSONSerialization.jsonObject(with: jsonData as Data, options:.mutableContainers)
        } catch  {
            //异常对象
            print(error)
        }
        //2- try! 直接告诉系统方法没有异常,如果出现了会崩溃
        
        //3- try? 方式 系统帮助我们处理异常,如果该方法出现了异常,系统会返回nil 常用方式
        guard let anyObject = try? JSONSerialization.jsonObject(with: jsonData as Data, options:.mutableContainers) else{
            
            return
        }
        guard let dicArray = anyObject as? [[String:AnyObject]] else{
            
            return
        }
        
        for dic in dicArray{
            
            //获取控制器对应的字符串             ?进行校验,是够能转成string
            guard let vcName = dic["vcName"] as? String else{
                
                continue
            }
            //获取title
            guard let title = dic["title"] as? String else {
                
                continue
            }
            //获取图标
            guard let imageName = dic["imageName"] as? String else{
                
                continue
            }
            addChildViewController(vcName, title: title, iconName: imageName)
        }
    }
    
    private func addChildViewController(_ childVC:String,title:String,iconName:String) -> Void {

        //0. 获取命名空间  转换成字符串类型的可选类型
        guard let nameSpace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else{
            print("no name space")
            return
        }
        //1, 获取类
        guard let ChildClass = NSClassFromString(nameSpace+"."+childVC) else {
            print("class dosen't find")
            return
        }
        //2. type拿到该类型  对应的AnyObject转换成控制器类型  因为class是AnyClass 不是我们需要的,转换成我们需要的
        guard let childType = ChildClass as? UIViewController.Type else {
            print("no class type")
            return;
        }
        
        //3. 创建控制器  根据某一个type init即可创建对象
        let childCtrl = childType.init()
        
        //4. 设置tab属性
        tabBar.tintColor = UIColor.orange
        childCtrl.title = title
        childCtrl.view.backgroundColor = UIColor.orange
        childCtrl.tabBarItem.image = UIImage(named: iconName)
        childCtrl.tabBarItem.selectedImage = UIImage(named:iconName+"_highlighted")

        //5. 包装导航
        let childNav = UINavigationController(rootViewController:childCtrl)
        addChildViewController(childNav)
    }
}
