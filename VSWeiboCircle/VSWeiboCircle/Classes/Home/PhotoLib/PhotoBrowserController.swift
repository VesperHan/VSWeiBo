//
//  PhotoBrowserController.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/19.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

private let PhotoBrowserCell = "PhotoBrowserCell"

class PhotoBrowserCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        itemSize = collectionView!.frame.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}

class PhotoBrowserController: UIViewController {

    var indexPath : IndexPath
    var picUrls:[NSURL]    

    fileprivate lazy var collectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowserCollectionViewLayout())
    
    fileprivate lazy var closeBtn : UIButton = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "关 闭")
    fileprivate lazy var saveBtn : UIButton = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "保 存")
    
    init(indexPath:IndexPath,picURLs:[NSURL]) {
        
        self.indexPath = indexPath
        self.picUrls = picURLs
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
}

extension PhotoBrowserController:PhotoBrowserViewDelegate{

    fileprivate func setupUI(){
    
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        collectionView.frame = view.bounds
        
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize.init(width: 90, height: 32))
        }
        
        saveBtn.snp.makeConstraints { (make) in
            
            make.right.equalTo(-20)
            make.bottom.equalTo(closeBtn.snp.bottom)
            make.size.equalTo(closeBtn.snp.size)
        }
        
        collectionView.register(PhotoBrowserViewCell.self, forCellWithReuseIdentifier: PhotoBrowserCell)
        collectionView.dataSource = self
        
        closeBtn.addTarget(self, action: #selector(closeBtnClk), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(saveBtnClk), for: .touchUpInside)
    }
    
    @objc func closeBtnClk(){
    
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imageViewClk() {
        
        closeBtnClk()
    }
    
    @objc func saveBtnClk(){
    
        let cell = collectionView.visibleCells.first as! PhotoBrowserViewCell
        
        guard let image = cell.imageView.image else {
            
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //void * 就是AnyObject
    @objc private func image(image : UIImage, didFinishSavingWithError error : NSError?, contextInfo : AnyObject) {
        
        var showInfo = ""
        if error != nil {
            showInfo = "保存失败"
        } else {
            showInfo = "保存成功"
        }
        
        SVProgressHUD.showSuccess(withStatus: showInfo)
    }
}

extension PhotoBrowserController:UICollectionViewDataSource,UICollectionViewDelegate{


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return picUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserCell, for: indexPath) as! PhotoBrowserViewCell
        
        cell.picURL = picUrls[indexPath.item]
        cell.delegate = self
        
        return cell
    }
}
