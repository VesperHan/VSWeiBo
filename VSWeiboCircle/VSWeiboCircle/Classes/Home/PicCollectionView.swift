//
//  PicCollectionView.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/12.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit
import SDWebImage

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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ShowPhotoBrowserNote), object: self, userInfo: userInfo)
    }
}

extension PicCollectionView : AnimatorPresentedDelegate{

    func startRect(indexPath: IndexPath) -> CGRect {
     
        //拿到cell
        let cell = self.cellForItem(at: indexPath)!
        
        let startFrame = self.convert(cell.frame, to: UIApplication.shared.keyWindow)
        
        return startFrame
    }
    
    func endRect(indexPath: IndexPath) -> CGRect {
        
        //获取image对象
        let picURL = picURLs[indexPath.item]
        let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picURL.absoluteString)
        
        //获取计算后的fanme
        let w = UIScreen.main.bounds.width
        let h = w / image!.size.width * image!.size.height
        var y :  CGFloat = 0
        
        if h > UIScreen.main.bounds.height{
            y = 0
        }else{
            
            y = (UIScreen.main.bounds.height - h) * 0.5
        }
        
        return CGRect(x: 0, y: y, width: w, height: h)
    }
    
    func imageView(indexPath: IndexPath) -> UIImageView {
        
        let imageView = UIImageView()
        
        let picURL = picURLs[indexPath.item]
        let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picURL.absoluteString)
        
        //设置属性
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
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
