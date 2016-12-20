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
        delegate = self
    }
}

extension PicCollectionView:UICollectionViewDataSource,UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return picURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picCellKey", for: indexPath) as! PicCollectionViewCell
        
        cell.picURL = picURLs[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //view是不能modal控制器的
        let userInfo = [ShowPhotoBrowserIndexKey : indexPath, ShowPhotoBrowserUrlsKey : picURLs] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ShowPhotoBrowserNote), object: nil, userInfo: userInfo)
    }
}

class PicCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    var picURL:URL? {
    
        didSet{
        
            guard let picURL = picURL else {
                
                return
            }
            iconView.sd_setImage(with: (getBigURL(smallURL: picURL)), placeholderImage: #imageLiteral(resourceName: "empty_picture"))
        }
    }
    
    private func getBigURL(smallURL:URL)->URL{
        
        let smallURLString = smallURL.absoluteString
        let bigURLString = smallURLString.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        
        return URL(string: bigURLString)!
    }
}
