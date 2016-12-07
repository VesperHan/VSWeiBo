//
//  TitleButton.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/6.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

class TitleButton: UIButton {

    override init(frame:CGRect){
    
        super.init(frame: frame)
        
        setImage(#imageLiteral(resourceName: "navigationbar_arrow_down"), for: .normal)
        setImage(#imageLiteral(resourceName: "navigationbar_arrow_up"), for: .selected)
        setTitle("Vesper", for: .normal)
        setTitleColor(UIColor.black, for: .normal)
        sizeToFit()
    }
    
    //swift中规定:重写控件init,必须重写init?(code aDecoder:NSCoder)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x  = titleLabel!.frame.size.width+8
    }
}
