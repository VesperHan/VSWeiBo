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
        }
    }
    //从Xib加载的内容会在这里加载
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
