//
//  PickPictureCollectionView.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/9/29.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit

private let picPickerCell = "picPickerCell"
private let margin : CGFloat = 15.0
public let ScreenW : CGFloat =  UIScreen.main.bounds.size.width
public let ScreenH : CGFloat =  UIScreen.main.bounds.size.height

class PickPictureCollectionView: UICollectionView {
    
//MARK:- 自定义属性
     lazy var images : [UIImage] = [UIImage]()
    
//MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        //1.设置布局
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = (ScreenW - margin * 4) / 3
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        
        //2.设置collectionView的属性
        register(UINib(nibName: "PickPikerViewCell", bundle: nil), forCellWithReuseIdentifier: picPickerCell)
        dataSource = self
        
        //3.设置collectionView的内边距
        contentInset = UIEdgeInsetsMake(margin, margin, 0, margin)
    }
}

extension PickPictureCollectionView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picPickerCell, for: indexPath) as! PickPikerViewCell
        //2.赋值cell
        cell.image = indexPath.item <= images.count - 1 ? images[indexPath.item] : nil
        
        //3.返回cell
        return cell
    }
}
