//
//  PickerViewCell.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/14.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

class PickerViewCell: UICollectionViewCell {

    @IBOutlet weak var addPhotoBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var image:UIImage?{
        
        didSet{
            if image != nil {
            
                imageView.image = image
                addPhotoBtn.isUserInteractionEnabled = false
                removeBtn.isHidden = false
            }else{
            
                imageView.image = nil
                addPhotoBtn.isUserInteractionEnabled = true
                removeBtn.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func addPhotoClk(_ sender: UIButton) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
    }
    
    @IBAction func removePhotoClk(_ sender: UIButton) {
        //直接传递该对象,要是用userInfo是为了传递数据很多的时候使用
        //object直接对应对象就可以
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicPickerRemovePhotoNote), object: imageView.image)
    }
}
