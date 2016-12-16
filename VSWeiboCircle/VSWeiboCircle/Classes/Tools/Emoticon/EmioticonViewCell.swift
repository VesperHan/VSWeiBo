//
//  EmioticonViewCell.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/16.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

class EmioticonViewCell: UICollectionViewCell {
 
    lazy var emoticonBtn : UIButton = UIButton()
    
    var emoticon :Emoticon?{
    
        didSet{
            guard let emoticon = emoticon else {
                return
            }
            emoticonBtn.setImage(UIImage.init(contentsOfFile: emoticon.pngPath ?? ""), for: .normal)
            emoticonBtn.setTitle(emoticon.emojiCode, for: .normal)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EmioticonViewCell {

    fileprivate func setupUI(){
    
        contentView.addSubview(emoticonBtn)
        emoticonBtn.frame = contentView.bounds
        
        emoticonBtn.isUserInteractionEnabled = false
        emoticonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
    }
}
