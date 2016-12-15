//
//  PicPickerCollectionView.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/14.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

private let  pickerCell = "pickerCell"
private let edgeMargin : CGFloat = 15
class PicPickerCollectionView: UICollectionView{

    var images:[UIImage] = [UIImage](){
    
        didSet{
            reloadData()
        }
    }
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        dataSource = self
       //register(PickerViewCell.self, forCellWithReuseIdentifier: pickerCell)
       //cell有xib的时候,一定要用load nib的方式注册cell
       register(UINib.init(nibName: "PickerViewCell", bundle: nil), forCellWithReuseIdentifier: pickerCell)
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let itemWH = (UIScreen.main.bounds.width - 4 * edgeMargin)/3
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumInteritemSpacing = edgeMargin
        layout.minimumLineSpacing = edgeMargin
        
        contentInset = UIEdgeInsetsMake(edgeMargin, edgeMargin, 0, edgeMargin)
    }

}

extension PicPickerCollectionView : UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pickerCell, for: indexPath) as! PickerViewCell
        cell.image = indexPath.item <= images.count - 1 ? images[indexPath.item]:nil
        
        return cell
    }
}
