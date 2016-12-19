//
//  HomeCell.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/11.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit
import SDWebImage
import HYLabel

class HomeCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var vipLevel: UIImageView!
    @IBOutlet weak var timeLb: UILabel!
    @IBOutlet weak var sourceLb: UILabel!
    @IBOutlet weak var contentLb: HYLabel!
    @IBOutlet weak var retweetText: HYLabel!
    
    @IBOutlet weak var retweetBgView: UIView!
    //collectionView 尺寸计算
    @IBOutlet weak var consWidth: NSLayoutConstraint!
    @IBOutlet weak var consHeight: NSLayoutConstraint!
    //collection距离底部约束
    @IBOutlet weak var consBottom: NSLayoutConstraint!
    //转发正文距离顶部的约束
    @IBOutlet weak var retweetConsTop: NSLayoutConstraint!
    
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
            
            sourceLb.text = "来自" + (viewModel.sourceText ?? "来自宇宙")
            contentLb.attributedText = FindEmoticon.shareIntance.findAttiString(statusText: viewModel.status?.text, font: contentLb.font)

            userName.textColor = viewModel.vipImage == nil ? UIColor.black : UIColor.orange
            
            //计算picview宽高
            let picViewSize = calculatePicViewSize(count: viewModel.picURLs.count)
            consWidth.constant = picViewSize.width
            consHeight.constant = picViewSize.height

            //传递picURl给picView
            picView.picURLs = viewModel.picURLs
            
            if viewModel.status?.retweeted_status != nil {
                if let userName = viewModel.status?.retweeted_status?.user?.screen_name,let retweetCont = viewModel.status?.retweeted_status?.text {
                    
                    let retweet = "@"+"\(userName):"+retweetCont
                    retweetText.attributedText = FindEmoticon.shareIntance.findAttiString(statusText: retweet, font: retweetText.font)
                }
                retweetBgView.isHidden = false
                retweetConsTop.constant = 10
            }else{
            
                retweetText.text = nil
                retweetBgView.isHidden = true
                retweetConsTop.constant = 0
            }
        }
    }
    //从Xib加载的内容会在这里加载
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconView.layer.cornerRadius = 20
        iconView.clipsToBounds = true
        
        //监听@谁
        contentLb.userTapHandler = {(labe,user,range) in}
        //监听链接的点击
        contentLb.linkTapHandler = {(label,link,range) in }
        //监听话题点击
        contentLb.topicTapHandler = {(label,topic,range) in }
    }
}

fileprivate let edgeMargin :CGFloat = 15
fileprivate let itemMargin :CGFloat = 10
extension HomeCell {

    fileprivate func calculatePicViewSize(count:Int) -> CGSize {
        
        if count == 0 {
            
            consBottom.constant = 0
            return CGSize.zero
        }
        consBottom.constant = 10
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
