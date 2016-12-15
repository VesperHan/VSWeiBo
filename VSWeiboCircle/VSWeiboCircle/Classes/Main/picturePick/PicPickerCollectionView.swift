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

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        dataSource = self
        register(PickerViewCell.self, forCellWithReuseIdentifier: pickerCell)
        
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
        
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pickerCell, for: indexPath)
        cell.backgroundColor = UIColor.red
        
        return cell
    }
}
