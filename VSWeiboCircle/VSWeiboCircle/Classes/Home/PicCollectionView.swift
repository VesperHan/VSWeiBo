//
//  PicCollectionView.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/12.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

class PicCollectionView: UICollectionView {

    var picURLs:[URL] = [URL](){
    
        didSet{
        
            self.reloadData()
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        dataSource = self
    }
}

extension PicCollectionView:UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return picURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picCellKey", for: indexPath) as! PicCollectionViewCell
        
        cell.picURL = picURLs[indexPath.item]
        
        return cell
    }
}

class PicCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    var picURL:URL? {
    
        didSet{
        
            guard let picURL = picURL else {
                
                return
            }
            iconView.sd_setImage(with: picURL, placeholderImage: #imageLiteral(resourceName: "empty_picture"))
        }
    }
}
