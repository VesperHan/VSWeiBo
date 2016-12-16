//
//  EmoticonController.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/15.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

class EmoticonController: UIViewController {

    fileprivate lazy var collectionView :UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmoticonCollectionViewLayout())

    fileprivate lazy var toolBar:UIToolbar = UIToolbar()
    
    fileprivate lazy var manager = EmoticonManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

extension EmoticonController{

    fileprivate func setupUI() {
    
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        collectionView.backgroundColor = UIColor.clear
        
        //子控件frame
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["toolBar":toolBar,"cView":collectionView] as [String:Any]
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[toolBar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cView]-0-[toolBar]-0-|", options: [.alignAllLeft,.alignAllRight], metrics: nil, views: views)
        view.addConstraints(cons)
        
        setupCollectionView()
        setupToolBar()
    }
    
    fileprivate func setupCollectionView(){
    
        collectionView.register(EmioticonViewCell.self, forCellWithReuseIdentifier: "emoticonCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    fileprivate func  setupToolBar(){
    
        let titles = ["最近","默认","emoji","浪小花"]
        var index = 0
        var tempItems = [UIBarButtonItem]()
        for title in titles {
            
            let item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(itemClk(item:)))
            item.tag = index
            index += 1
            
            tempItems.append(item)
            tempItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        tempItems.removeLast()
        toolBar.items = tempItems
        toolBar.tintColor = UIColor.orange
    }
    
    @objc func itemClk(item:UIBarButtonItem){
    
        let tag = item.tag
        
        let indexPath = IndexPath(item: 0, section: tag)
        
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
}

extension EmoticonController:UICollectionViewDataSource,UICollectionViewDelegate{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
    
        return manager.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let package = manager.packages[section]
        return package.emoticons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emoticonCell", for: indexPath) as! EmioticonViewCell
        let  package = manager.packages[indexPath.section]
        let  emoticon = package.emoticons[indexPath.item]
        cell.emoticon = emoticon
        return cell
    }
    
    //delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //取出点击的表情
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        
        insertRecentlyEmoticon(emoticon: emoticon)
    }
    
    private func insertRecentlyEmoticon(emoticon:Emoticon){
    
        if emoticon.isRemove || emoticon.isEmpty {
            return
        }
        //没往最近分组新插入一个表情,都要删除一个空白表情,防止删除被移走
        //重复表情也要删除
        if manager.packages.first!.emoticons.contains(emoticon) {
            
            //如果最近表情存在该表情,则先删除
            let index = manager.packages.first?.emoticons.index(of: emoticon)!
            manager.packages.first?.emoticons.remove(at: index!)
        }else{
            
            //如果最近表情没有该表情
            manager.packages.first?.emoticons.remove(at: 19)
        }
        
        //插入表情
        manager.packages.first?.emoticons.insert(emoticon, at: 0)
    }
}

class EmoticonCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        let itemWH = UIScreen.main.bounds.width / 7
        
        itemSize = CGSize(width: itemWH, height: itemWH)
        //水平时行间距 垂直时为列间距
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .horizontal
        
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        
        let insetMargin = (collectionView!.bounds.height - 3 * itemWH) / 2
        collectionView?.contentInset = UIEdgeInsets(top: insetMargin, left: 0, bottom: insetMargin, right: 0)
    }
}
