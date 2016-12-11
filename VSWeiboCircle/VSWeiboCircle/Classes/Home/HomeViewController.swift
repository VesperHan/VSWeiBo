//
//  HomeViewController.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/2.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    fileprivate lazy var titleBtn:TitleButton = TitleButton()
    //Array
    fileprivate lazy var viewModels : [StatusViewModel] = [StatusViewModel]()
    //设置弹出动画样式 弹出时间 风格...
    //在闭包中使用当前对象的属性或者方法,需要加self
    //两个地方使用self, 1. 如果出现歧义则使用  2. 在闭包中
    fileprivate lazy var popoverAnimator:PopoverAnimator = PopoverAnimator {[weak self](present) in
        
        self?.titleBtn.isSelected = present
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
        loadStatus()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
    }
}

// MARK:- 设置UI
extension HomeViewController {

    // 导航设置
    fileprivate func setupNav() {

        //两种便利构造函数
        navigationItem.leftBarButtonItem = UIBarButtonItem(fontImage: #imageLiteral(resourceName: "navigationbar_friendattention"), imageHight: #imageLiteral(resourceName: "navigationbar_friendattention_highlighted"))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "navigationbar_pop"), imageHight: #imageLiteral(resourceName: "navigationbar_pop_highlighted"))
        
        navigationItem.titleView = titleBtn
        
        titleBtn.addTarget(self, action: #selector(titleBtnClick(sender:)), for: .touchUpInside)
    }
}

//事件监听
extension HomeViewController {

    @objc fileprivate func titleBtnClick(sender:TitleButton) {
        
        // 设置显示样式 显示大小 蒙版...
        let popOverView = PopoverViewController()
        popOverView.modalPresentationStyle = .custom
        
        //设置转场代理,自定义视图的大小  动画样式代理
        popOverView.transitioningDelegate = popoverAnimator
        present(popOverView, animated: true, completion: nil)

    }
}

// MARK:- 请求数据
extension HomeViewController {

    fileprivate func loadStatus(){
    
        VSNetworkTools.shareInstance.loadStatus { (result, error) in
            
            if error != nil{
                
                Errolog(error)
                return
            }
            guard let resultArr = result else {
                return
            }
            for statusDict in resultArr {
            
                let status = Status(dict: statusDict)
                let viewModel = StatusViewModel(status: status)
                self.viewModels.append(viewModel)
            }
            
            self.tableView.reloadData()
        }
    }
}

extension HomeViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //创建cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeKey", for: indexPath) as! HomeCell

        let status = viewModels[indexPath.row]
        cell.viewModel = status
        return cell
    }
}
