//
//  BaseViewController.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/5.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {

    
    var isLogin = true
    lazy var visitorView = VisitorView.visitorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItems()
    }
    
    override func loadView() {
        
        isLogin ? super.loadView() : setupVistorView()
    }

}

// MARK:- 设置UI界面
extension BaseViewController {

    func setupVistorView(){
        visitorView.addRotationAnim()
        view = visitorView
        visitorView.registerBtn.addTarget(self, action: #selector(registerBtnClick), for: .touchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(loginBtnClick), for: .touchUpInside)
    }
    
    fileprivate func setupNavigationItems() -> Void {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain,target:self, action:#selector(registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登陆", style: .plain, target: self, action: #selector(loginBtnClick))
    }
}

//// MARK:- 事件监听
extension BaseViewController{

    @objc fileprivate func registerBtnClick() {
    
        print(1)
    }
    @objc fileprivate func loginBtnClick() {
    
        print(2)
    }
}
