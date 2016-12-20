//
//  PhotoBrowserViewCell.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/19.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoBrowserViewDelegate : NSObjectProtocol{
    
    func imageViewClk()
}

class PhotoBrowserViewCell: UICollectionViewCell {
    
    var picURL :NSURL?{
    
        didSet{
            
           setupContent(picURL: picURL)
        }
    }
    
    var delegate : PhotoBrowserViewDelegate?

    fileprivate lazy var scrollView : UIScrollView = UIScrollView()
                lazy var imageView : UIImageView = UIImageView()
    fileprivate lazy var progressView:ProgressView = ProgressView()
    
    override init(frame:CGRect){
    
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoBrowserViewCell{

    fileprivate func setupUI(){
    
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        contentView.addSubview(progressView)
        
        scrollView.frame = contentView.bounds
        progressView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        
        // 3.设置控件的属性
        progressView.isHidden = true
        progressView.backgroundColor = UIColor.clear
        
        // imageView点击
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewClk))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
    }
    
    @objc private func imageViewClk(){
    
        delegate?.imageViewClk()
    }

    fileprivate func setupContent(picURL:NSURL?){
    
        guard let picURL  = picURL else {
            return
        }
        
        let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picURL.absoluteString)
        
        if image == nil {
            return
        }
        
        let width = UIScreen.main.bounds.width
        
        //当前屏幕的宽是照片宽度的几倍 等比之后诚意原始高度 结果是放大高度
        let height = width / image!.size.width * image!.size.height
        var y : CGFloat = 0
        if height > UIScreen.main.bounds.height{
            y = 0
        }else{
            
            y = (UIScreen.main.bounds.height - height) * 0.5
        }
        
        imageView.frame = CGRect(x: 0, y: y, width: width, height: height)
        
        self.progressView.isHidden = false
        imageView.sd_setImage(with: getBigURL(smallURL: picURL) as URL!, placeholderImage: image, options: [], progress: { (current, total) in
                
                self.progressView.pregress = CGFloat(current)/CGFloat(total)
        }) { (_, _, _, _) in
            
            self.progressView.isHidden = true
        }
        scrollView.contentSize = CGSize(width: 0, height: height)
    }
    
    private func getBigURL(smallURL:NSURL)->NSURL{
    
        let smallURLString = smallURL.absoluteString
        let bigURLString = smallURLString?.replacingOccurrences(of: "thumbnail", with: "large")
        
        return NSURL(string: bigURLString!)!
    }
}
