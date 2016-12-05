//
//  BaseViewController.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/5.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {

    
    var isLogin = false
    lazy var visitorView = VisitorView.visitorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func loadView() {
        
        isLogin ? super.loadView() : setupVistorView()
    }

}

extension BaseViewController {

     func setupVistorView(){
        
        visitorView.backgroundColor = UIColor.purple
        view = visitorView
    }
}
