//
//  HomeViewController.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/2.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD
import SnapKit
import MJRefresh

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
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        setupHeaderView()
        setupFooterView()
    }
    
    func tmpCodeLayout(){
        
        refreshControl = UIRefreshControl()
        let demoView = UIView()
        refreshControl?.addSubview(demoView)
        demoView.snp.makeConstraints { (ConstraintMaker) in
            
            ConstraintMaker.centerX.equalTo(self.view)
        }
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
    
    fileprivate func setupHeaderView(){
        
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNewStatus))
        
        tableView.mj_header = header
        
        tableView.mj_header.beginRefreshing()
    }
    
    fileprivate func setupFooterView(){
    
        tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction:#selector(loadMoreStatus))
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
    
    @objc fileprivate func loadNewStatus(){
    
                loadStatus(true)
    }
    
    @objc fileprivate func loadMoreStatus(){
    
                loadStatus(false)
    }
}

// MARK:- 请求数据
extension HomeViewController {

    fileprivate func loadStatus(_ isNewData:Bool){
        SVProgressHUD.show()
        var since_id = 0
        var max_id = 0
        
        if isNewData {
            
            since_id = viewModels.first?.status?.mid ?? 0
        }else{
        
            max_id = viewModels.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
        
        VSNetworkTools.shareInstance.loadStatus(since_id,max_id){(result, error) in
            
            if error != nil{
                
                Errolog(error)
                return
            }
            guard let resultArr = result else {
                return
            }
            
            var tmpViewModel = [StatusViewModel]()
            for statusDict in resultArr {
            
                let status = Status(dict: statusDict)
                let viewModel = StatusViewModel(status: status)
                tmpViewModel.append(viewModel)
            }
            
            if isNewData {
            
                self.viewModels = tmpViewModel + self.viewModels
            }else{
                
                self.viewModels += tmpViewModel
            }
            
            self.cacheImages(viewModels: tmpViewModel)
        }
    }
    
    //图片缓存策略
    //目的:解决图片比例未知问题,获取真实图片大小并显示
    private func cacheImages(viewModels:[StatusViewModel]){
    
        //所有异步操作完成之后再刷新
        //进入组之后进行异步操作,执行完成之后离开组,然后刷新表格
        let group = DispatchGroup()
        
        for viewmodel in viewModels {
            for picUrl in viewmodel.picURLs {
                
                group.enter()
                SDWebImageManager.shared().downloadImage(with: picUrl, options: [], progress: nil, completed: { (_, _, _, _, _) in
                    group.leave()
                })
            }
        }
        group.notify(queue: DispatchQueue.main) {
            
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            SVProgressHUD.dismiss()
        }
    }
}

// MARK:- tableview delegate
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
