//
//  HomeCell.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/11.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit
import SDWebImage

class HomeCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var vipLevel: UIImageView!
    @IBOutlet weak var timeLb: UILabel!
    @IBOutlet weak var sourceLb: UILabel!
    @IBOutlet weak var contentLb: UILabel!
    @IBOutlet weak var retweetText: UILabel!
    //collectionView 尺寸计算
    @IBOutlet weak var consWidth: NSLayoutConstraint!
    @IBOutlet weak var consHeight: NSLayoutConstraint!
    
    @IBOutlet weak var picView: PicCollectionView!
    
    var viewModel:StatusViewModel?{

        didSet{
            //guard 空值检验
            guard let viewModel = viewModel else {
                return
            }
            //设置头像
            iconView.sd_setImage(with: viewModel.profileUrl, placeholderImage: #imageLiteral(resourceName: "avatar_default_small"))
            
            verifiedView.image = viewModel.verifiedImage
            userName.text = viewModel.status?.user?.screen_name
            vipLevel.image = viewModel.vipImage
            timeLb.text = viewModel.createAtText
            sourceLb.text = viewModel.sourceText
            contentLb.text = viewModel.status?.text
            
            userName.textColor = viewModel.vipImage == nil ? UIColor.black : UIColor.orange
            
            //计算picview宽高
            let picViewSize = calculatePicViewSize(count: viewModel.picURLs.count)
            consWidth.constant = picViewSize.width
            consHeight.constant = picViewSize.height
            
            Infolog(NSStringFromCGSize(picViewSize))
            Infolog(NSStringFromCGRect(picView.frame))
            //传递picURl给picView
            picView.picURLs = viewModel.picURLs
            
            if viewModel.status?.retweeted_status != nil {
                if let userName = viewModel.status?.retweeted_status?.user?.screen_name,let retweetCont = viewModel.status?.retweeted_status?.text {
                    
                    retweetText.text = "@"+"\(userName):"+retweetCont
                }
            }else{
            
                retweetText.text = nil
            }
        }
    }
    //从Xib加载的内容会在这里加载
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconView.layer.cornerRadius = 40
        iconView.clipsToBounds = true
    }
}

fileprivate let edgeMargin :CGFloat = 15
fileprivate let itemMargin :CGFloat = 10
extension HomeCell {

    fileprivate func calculatePicViewSize(count:Int) -> CGSize {
        
        if count == 0 {
            
            return CGSize.zero
        }
        
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout

        //单张配图
        if count == 1 {
            
            let urlString = viewModel?.picURLs.last?.absoluteString
            let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: urlString)
            
            layout.itemSize = CGSize(width: (image?.size.width)!*2, height: (image?.size.height)!*2)
            
            return layout.itemSize
            
        }
        //计算多张配图的时候图片尺寸
        let imageViewWH = (UIScreen.main.bounds.width - 2*itemMargin - 2*edgeMargin)/3

        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
        
        //四张配图
        if count == 4{
        
            let picViewWH = imageViewWH*2 + itemMargin
            return CGSize(width: picViewWH, height: picViewWH)
        }
        
        //其他张配图
        let  rows = CGFloat((count - 1) / 3 + 1)
        //picView高度计算
        let picViewW = UIScreen.main.bounds.width - 2 * edgeMargin
        let picViewH = rows*imageViewWH+(rows-1)*itemMargin
        
        return CGSize(width: picViewW, height: picViewH)
    }
}
